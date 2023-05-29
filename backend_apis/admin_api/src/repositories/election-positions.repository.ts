import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {PostgresDataSource} from '../datasources';
import {ElectionPositions, ElectionPositionsRelations} from '../models';

export class ElectionPositionsRepository extends DefaultCrudRepository<
  ElectionPositions,
  typeof ElectionPositions.prototype.positionId,
  ElectionPositionsRelations
> {
  constructor(
    @inject('datasources.Postgres') dataSource: PostgresDataSource,
  ) {
    super(ElectionPositions, dataSource);
  }
}
