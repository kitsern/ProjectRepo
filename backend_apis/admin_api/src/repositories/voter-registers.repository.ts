import {inject, Getter} from '@loopback/core';
import {DefaultCrudRepository, repository, HasManyThroughRepositoryFactory} from '@loopback/repository';
import {PostgresDataSource} from '../datasources';
import {VoterRegisters, VoterRegistersRelations, Users, VoterRegisterUsers} from '../models';
import {VoterRegisterUsersRepository} from './voter-register-users.repository';
import {UsersRepository} from './users.repository';

export class VoterRegistersRepository extends DefaultCrudRepository<
  VoterRegisters,
  typeof VoterRegisters.prototype.registerId,
  VoterRegistersRelations
> {

  public readonly users: HasManyThroughRepositoryFactory<Users, typeof Users.prototype.userId,
          VoterRegisterUsers,
          typeof VoterRegisters.prototype.registerId
        >;

  constructor(
    @inject('datasources.Postgres') dataSource: PostgresDataSource, @repository.getter('VoterRegisterUsersRepository') protected voterRegisterUsersRepositoryGetter: Getter<VoterRegisterUsersRepository>, @repository.getter('UsersRepository') protected usersRepositoryGetter: Getter<UsersRepository>,
  ) {
    super(VoterRegisters, dataSource);
    this.users = this.createHasManyThroughRepositoryFactoryFor('users', usersRepositoryGetter, voterRegisterUsersRepositoryGetter,);
    this.registerInclusionResolver('users', this.users.inclusionResolver);
  }
}
