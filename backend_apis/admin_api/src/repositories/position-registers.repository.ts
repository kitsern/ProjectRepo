import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {PostgresDataSource} from '../datasources';
import {PositionRegisters, PositionRegistersRelations} from '../models';

export class PositionRegistersRepository extends DefaultCrudRepository<
  PositionRegisters,
  typeof PositionRegisters.prototype.positionRegisterId,
  PositionRegistersRelations
> {
  constructor(
    @inject('datasources.Postgres') dataSource: PostgresDataSource,
  ) {
    super(PositionRegisters, dataSource);
  }
}
