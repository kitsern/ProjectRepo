import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {PostgresDataSource} from '../datasources';
import {ElectionInstances, ElectionInstancesRelations} from '../models';

export class ElectionInstancesRepository extends DefaultCrudRepository<
  ElectionInstances,
  typeof ElectionInstances.prototype.electionId,
  ElectionInstancesRelations
> {
  constructor(
    @inject('datasources.Postgres') dataSource: PostgresDataSource,
  ) {
    super(ElectionInstances, dataSource);
  }
}
