import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {PostgresDataSource} from '../datasources';
import {PollingStations, PollingStationsRelations} from '../models';

export class PollingStationsRepository extends DefaultCrudRepository<
  PollingStations,
  typeof PollingStations.prototype.stationId,
  PollingStationsRelations
> {
  constructor(
    @inject('datasources.Postgres') dataSource: PostgresDataSource,
  ) {
    super(PollingStations, dataSource);
  }
}
