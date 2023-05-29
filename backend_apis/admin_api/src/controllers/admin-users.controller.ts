import {
  Count,
  CountSchema,
  Filter,
  FilterExcludingWhere,
  repository,
  Where,
} from '@loopback/repository';
import {
  post,
  param,
  get,
  getModelSchemaRef,
  patch,
  put,
  del,
  requestBody,
  response,
} from '@loopback/rest';
import {AdminUsers} from '../models';
import {AdminUsersRepository} from '../repositories';

export class AdminUsersController {
  constructor(
    @repository(AdminUsersRepository)
    public adminUsersRepository : AdminUsersRepository,
  ) {}

  @post('/admin-users')
  @response(200, {
    description: 'AdminUsers model instance',
    content: {'application/json': {schema: getModelSchemaRef(AdminUsers)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(AdminUsers, {
            title: 'NewAdminUsers',
            exclude: ['userId'],
          }),
        },
      },
    })
    adminUsers: Omit<AdminUsers, 'userId'>,
  ): Promise<AdminUsers> {
    return this.adminUsersRepository.create(adminUsers);
  }

  @get('/admin-users/count')
  @response(200, {
    description: 'AdminUsers model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(AdminUsers) where?: Where<AdminUsers>,
  ): Promise<Count> {
    return this.adminUsersRepository.count(where);
  }

  @get('/admin-users')
  @response(200, {
    description: 'Array of AdminUsers model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(AdminUsers, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(AdminUsers) filter?: Filter<AdminUsers>,
  ): Promise<AdminUsers[]> {
    return this.adminUsersRepository.find(filter);
  }

  @patch('/admin-users')
  @response(200, {
    description: 'AdminUsers PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(AdminUsers, {partial: true}),
        },
      },
    })
    adminUsers: AdminUsers,
    @param.where(AdminUsers) where?: Where<AdminUsers>,
  ): Promise<Count> {
    return this.adminUsersRepository.updateAll(adminUsers, where);
  }

  @get('/admin-users/{id}')
  @response(200, {
    description: 'AdminUsers model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(AdminUsers, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(AdminUsers, {exclude: 'where'}) filter?: FilterExcludingWhere<AdminUsers>
  ): Promise<AdminUsers> {
    return this.adminUsersRepository.findById(id, filter);
  }

  @patch('/admin-users/{id}')
  @response(204, {
    description: 'AdminUsers PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(AdminUsers, {partial: true}),
        },
      },
    })
    adminUsers: AdminUsers,
  ): Promise<void> {
    await this.adminUsersRepository.updateById(id, adminUsers);
  }

  @put('/admin-users/{id}')
  @response(204, {
    description: 'AdminUsers PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() adminUsers: AdminUsers,
  ): Promise<void> {
    await this.adminUsersRepository.replaceById(id, adminUsers);
  }

  @del('/admin-users/{id}')
  @response(204, {
    description: 'AdminUsers DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.adminUsersRepository.deleteById(id);
  }
}
