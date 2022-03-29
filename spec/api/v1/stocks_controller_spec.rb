# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::StocksController, type: :request do
  let(:response_body) { JSON.parse(response.body, symbolize_names: true) }
  let(:headers) do
    { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
  end

  let(:stock_name) { 'Stock' }
  let(:bearer_name) { 'Bearer' }

  let(:bearer) { create(:bearer, name: bearer_name) }
  let(:stock) { create(:stock, bearer: bearer, name: stock_name) }

  def serialized_stock_with_bearer(stock, bearer, stock_name)
    {
      id: stock.id,
      type: 'stock',
      attributes: {
        name: stock_name
      },
      relationships: {
        bearer: {
          data: {
            id: bearer.id,
            type: 'bearer'
          }
        }
      }
    }
  end

  shared_examples :record_not_found do
    context 'not found' do
      before { request('does-not-exist') }

      let(:expected_response_body) do
        {
          errors: [
            {
              detail: "Couldn't find Stock with 'id'=does-not-exist"
            }
          ]
        }
      end

      it 'returns status 404' do
        expect(response.code).to eq '404'
      end

      it 'returns expected response body' do
        expect(response_body).to eq(expected_response_body)
      end
    end
  end

  shared_examples :record_not_unique do
    let(:expected_response_body) do
      {
        errors: [
          { detail: 'Stock, Validation failed: Name has already been taken' }
        ]
      }
    end

    it 'returns status 422' do
      expect(response.code).to eq '422'
    end

    it 'returns expected response body' do
      expect(response_body).to eq expected_response_body
    end
  end

  describe 'GET api/stocks' do
    def request
      get '/api/stocks',
          headers: headers,
          xhr: true
    end

    context 'response structure' do
      before do
        stock
        request
      end

      let(:expected_response_body) do
        {
          data: [
            serialized_stock_with_bearer(stock, bearer, stock_name)
          ],
          included: [
            {
              attributes: { name: bearer_name },
              id: bearer.id,
              type: 'bearer'
            }
          ],
          links: {
            first: '/api/stocks?page=1',
            last: '/api/stocks?page=1'
          }
        }
      end

      it 'returns status 200' do
        expect(response.code).to eq '200'
      end

      it 'returns expected response body' do
        expect(response_body).to eq expected_response_body
      end
    end

    context 'pagination' do
      before do
        create_list(:stock, 100, :sequence_stock_name, bearer: bearer)
        request
      end

      shared_examples :pagination do
        it 'returns expected number of records' do
          expect(response_body[:data].size).to eq(25)
        end

        it 'returns expected response body' do
          expect(response_body[:links]).to eq(links)
        end
      end

      let(:links) do
        {
          first: '/api/stocks?page=1',
          last: '/api/stocks?page=4',
          next: '/api/stocks?page=2'
        }
      end

      include_examples :pagination

      context 'page number is present' do
        def request
          get '/api/stocks?page=2',
              headers: headers,
              xhr: true
        end

        let(:links) do
          {
            first: '/api/stocks?page=1',
            last: '/api/stocks?page=4',
            next: '/api/stocks?page=3',
            prev: '/api/stocks?page=1'
          }
        end

        include_examples :pagination
      end
    end
  end

  describe 'POST api/stocks' do
    def request
      post '/api/stocks',
           params: params, as: :json,
           headers: headers,
           xhr: true
    end

    let(:operation) { double(success?: true, stock: stock) }

    let(:params) do
      {
        data: {
          stock_attributes: {
            name: stock_name
          },
          bearer_attributes: {
            name: bearer_name
          }
        }
      }
    end

    context 'success' do
      let(:expected_response_body) do
        {
          data: serialized_stock_with_bearer(stock, bearer, stock_name),
          included: [
            {
              attributes: { name: bearer_name },
              id: bearer.id,
              type: 'bearer'
            }
          ]
        }
      end

      before do
        allow(Stocks::Create).to receive(:call).and_return(operation)
        request
      end

      it 'returns status 201' do
        expect(response.code).to eq '201'
      end

      it 'returns expected response body' do
        expect(response_body).to eq(expected_response_body)
      end
    end

    context 'failure' do
      context 'invalid params' do
        before do
          params[:data].delete(:stock_attributes)
          params[:data][:bearer_attributes].delete(:name)
          request
        end

        let(:expected_response_body) do
          {
            errors: [
              {
                detail: {
                  data: {
                    bearer_attributes: {
                      name: ['is missing']
                    },
                    stock_attributes: ['is missing']
                  }
                }
              }
            ]
          }
        end

        it 'returns status 400' do
          expect(response.code).to eq '400'
        end

        it 'returns expected response body' do
          expect(response_body).to eq expected_response_body
        end
      end

      context 'record not unique' do
        before do
          stock
          request
        end

        include_examples :record_not_unique
      end
    end
  end

  describe 'PATCH api/stocks/:id' do
    def request(stock_id)
      patch "/api/stocks/#{stock_id}",
            params: params, as: :json,
            headers: headers,
            xhr: true
    end

    let(:new_stock_name) { 'New Stock' }

    let(:params) do
      {
        data: {
          stock_attributes: {
            name: new_stock_name
          }
        }
      }
    end

    context 'success' do
      let(:expected_response_body) do
        {
          data: serialized_stock_with_bearer(stock, bearer, new_stock_name),
          included: [
            {
              attributes: { name: bearer_name },
              id: bearer.id,
              type: 'bearer'
            }
          ]
        }
      end

      before { request(stock.id) }

      it 'returns status 200' do
        expect(response.code).to eq '200'
      end

      it 'returns expected response body' do
        expect(response_body).to eq expected_response_body
      end
    end

    context 'failure' do
      include_examples :record_not_found

      context 'invalid params' do
        before do
          params[:data][:stock_attributes].delete(:name)
          request(stock.id)
        end

        let(:expected_response_body) do
          {
            errors: [
              {
                detail: {
                  data: {
                    stock_attributes: {
                      name: ['is missing']
                    }
                  }
                }
              }
            ]
          }
        end

        it 'returns status 400' do
          expect(response.code).to eq '400'
        end

        it 'returns expected response body' do
          expect(response_body).to eq expected_response_body
        end
      end

      context 'name has been taken' do
        before do
          create(:stock, name: new_stock_name, bearer: bearer)
          request(stock.id)
        end

        include_examples :record_not_unique
      end
    end
  end

  describe 'DELETE api/stocks/:id' do
    def request(stock_id)
      delete "/api/stocks/#{stock_id}",
             headers: headers,
             xhr: true
    end

    before { stock }

    it 'calls the expected operation' do
      expect(Stocks::Destroy).to receive(:call).with(id: stock.id).and_call_original
      request(stock.id)
    end

    context 'success' do
      before { request(stock.id) }

      it 'returns status 204' do
        expect(response.code).to eq '204'
      end

      it 'returns expected response body' do
        expect(response.body).to be_blank
      end
    end

    context 'failure' do
      include_examples :record_not_found

      context 'cannot be destroyed' do
        let(:error_messages) do
          ['Record cannot be destroyed']
        end

        let(:operation) { double(success?: false, errors: error_messages) }

        before do
          allow(Stocks::Destroy).to receive(:call).and_return(operation)
          request(stock.id)
        end

        let(:expected_response_body) do
          {
            errors: [
              {
                detail: 'Record cannot be destroyed'
              }
            ]
          }
        end

        it 'returns status 422' do
          expect(response.code).to eq '422'
        end

        it 'returns expected response body' do
          expect(response_body).to eq(expected_response_body)
        end
      end
    end
  end
end
