import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {PostgresDataSource} from '../datasources';
import {Votes, VotesRelations} from '../models';

export class VotesRepository extends DefaultCrudRepository<
  Votes,
  typeof Votes.prototype.voteId,
  VotesRelations
> {
  constructor(
    @inject('datasources.Postgres') dataSource: PostgresDataSource,
  ) {
    super(Votes, dataSource);
  }
}
