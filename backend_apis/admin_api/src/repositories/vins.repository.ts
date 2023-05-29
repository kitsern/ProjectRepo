import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {PostgresDataSource} from '../datasources';
import {Vins, VinsRelations} from '../models';

export class VinsRepository extends DefaultCrudRepository<
  Vins,
  typeof Vins.prototype.vinId,
  VinsRelations
> {
  constructor(
    @inject('datasources.Postgres') dataSource: PostgresDataSource,
  ) {
    super(Vins, dataSource);
  }
}
