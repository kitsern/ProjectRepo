import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {PostgresDataSource} from '../datasources';
import {Candidates, CandidatesRelations} from '../models';

export class CandidatesRepository extends DefaultCrudRepository<
  Candidates,
  typeof Candidates.prototype.candidateId,
  CandidatesRelations
> {
  constructor(
    @inject('datasources.Postgres') dataSource: PostgresDataSource,
  ) {
    super(Candidates, dataSource);
  }
}
