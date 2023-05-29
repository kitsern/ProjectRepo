import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {PostgresDataSource} from '../datasources';
import {PollingSReturningO, PollingSReturningORelations} from '../models';

export class PollingSReturningORepository extends DefaultCrudRepository<
  PollingSReturningO,
  typeof PollingSReturningO.prototype.returningOfficerId,
  PollingSReturningORelations
> {
  constructor(
    @inject('datasources.Postgres') dataSource: PostgresDataSource,
  ) {
    super(PollingSReturningO, dataSource);
  }
}
