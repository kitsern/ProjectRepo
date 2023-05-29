import {inject, lifeCycleObserver, LifeCycleObserver} from '@loopback/core';
import {juggler} from '@loopback/repository';

const config = {
  name: 'Postgres',
  connector: 'postgresql',
  url: 'postgres://admin:admin123@localhost:5432/postgres',
  host: '',
  port: 0,
  user: '',
  password: '',
  database: ''
};

// Observe application's life cycle to disconnect the datasource when
// application is stopped. This allows the application to be shut down
// gracefully. The `stop()` method is inherited from `juggler.DataSource`.
// Learn more at https://loopback.io/doc/en/lb4/Life-cycle.html
@lifeCycleObserver('datasource')
export class PostgresDataSource extends juggler.DataSource
  implements LifeCycleObserver {
  static dataSourceName = 'Postgres';
  static readonly defaultConfig = config;

  constructor(
    @inject('datasources.config.Postgres', {optional: true})
    dsConfig: object = config,
  ) {
    super(dsConfig);
  }
}
