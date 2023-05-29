import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {PostgresDataSource} from '../datasources';
import {VoterRegisterUsers, VoterRegisterUsersRelations} from '../models';

export class VoterRegisterUsersRepository extends DefaultCrudRepository<
  VoterRegisterUsers,
  typeof VoterRegisterUsers.prototype.voterUserId,
  VoterRegisterUsersRelations
> {
  constructor(
    @inject('datasources.Postgres') dataSource: PostgresDataSource,
  ) {
    super(VoterRegisterUsers, dataSource);
  }
}
