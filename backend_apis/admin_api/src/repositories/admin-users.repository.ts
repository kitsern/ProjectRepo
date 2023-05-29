import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {PostgresDataSource} from '../datasources';
import {AdminUsers, AdminUsersRelations} from '../models';

export class AdminUsersRepository extends DefaultCrudRepository<
  AdminUsers,
  typeof AdminUsers.prototype.userId,
  AdminUsersRelations
> {
  constructor(
    @inject('datasources.Postgres') dataSource: PostgresDataSource,
  ) {
    super(AdminUsers, dataSource);
  }
}
