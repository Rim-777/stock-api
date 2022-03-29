## Stock Api
Ruby Rails application for JSON-API with ActiveRecord, RSpec
### Dependencies:
- Ruby 2.7.5
- PostgreSQL

### Description
The application manages stocks and bearers

### Installation:
- Clone poject
- Run bundler:

 ```shell
 $ bundle install
 ```
- Create database.yml:
```shell
$ cp config/database.yml.sample config/database.yml
```

- Run application:

 ```shell
 $ rails server
 ```

##### Tests:
To execute tests, run following commands:

```shell
 $ bundle exec rake db:migrate RAILS_ENV=test #(the first time only)
 $ bundle exec rspec
```

### Explanation of the approach:
DDD Service-based app design with step-based operations 

#### Common logic:
Sock API with 4 endpoints:
1) GET ```api/stocks``` - returns a list of available stocks with related bearers
2) POST ```api/stocks``` - creates a stock and links it to the bearer, if the bearer doesn't exist it will be created
3) PATCH ```api/stocks``` - updates a stock, if bearer attributes are present, finds or creates a new bearer
4) DELETE ```api/stocks``` - deletes a stock from the API

[See Swagger Docs](https://app.swaggerhub.com/apis/Rim-777/Stock/1.0.0#/IndexStock)
### License

The software is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
