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
import {VoterRegisterUsers} from '../models';
import {VoterRegisterUsersRepository} from '../repositories';

export class VoterRegisterUsersController {
  constructor(
    @repository(VoterRegisterUsersRepository)
    public voterRegisterUsersRepository : VoterRegisterUsersRepository,
  ) {}

  @post('/voter-register-users')
  @response(200, {
    description: 'VoterRegisterUsers model instance',
    content: {'application/json': {schema: getModelSchemaRef(VoterRegisterUsers)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(VoterRegisterUsers, {
            title: 'NewVoterRegisterUsers',
            exclude: ['voterUserId'],
          }),
        },
      },
    })
    voterRegisterUsers: Omit<VoterRegisterUsers, 'voterUserId'>,
  ): Promise<VoterRegisterUsers> {
    return this.voterRegisterUsersRepository.create(voterRegisterUsers);
  }

  @get('/voter-register-users/count')
  @response(200, {
    description: 'VoterRegisterUsers model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(VoterRegisterUsers) where?: Where<VoterRegisterUsers>,
  ): Promise<Count> {
    return this.voterRegisterUsersRepository.count(where);
  }

  @get('/voter-register-users')
  @response(200, {
    description: 'Array of VoterRegisterUsers model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(VoterRegisterUsers, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(VoterRegisterUsers) filter?: Filter<VoterRegisterUsers>,
  ): Promise<VoterRegisterUsers[]> {
    return this.voterRegisterUsersRepository.find(filter);
  }

  @patch('/voter-register-users')
  @response(200, {
    description: 'VoterRegisterUsers PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(VoterRegisterUsers, {partial: true}),
        },
      },
    })
    voterRegisterUsers: VoterRegisterUsers,
    @param.where(VoterRegisterUsers) where?: Where<VoterRegisterUsers>,
  ): Promise<Count> {
    return this.voterRegisterUsersRepository.updateAll(voterRegisterUsers, where);
  }

  @get('/voter-register-users/{id}')
  @response(200, {
    description: 'VoterRegisterUsers model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(VoterRegisterUsers, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(VoterRegisterUsers, {exclude: 'where'}) filter?: FilterExcludingWhere<VoterRegisterUsers>
  ): Promise<VoterRegisterUsers> {
    return this.voterRegisterUsersRepository.findById(id, filter);
  }

  @patch('/voter-register-users/{id}')
  @response(204, {
    description: 'VoterRegisterUsers PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(VoterRegisterUsers, {partial: true}),
        },
      },
    })
    voterRegisterUsers: VoterRegisterUsers,
  ): Promise<void> {
    await this.voterRegisterUsersRepository.updateById(id, voterRegisterUsers);
  }

  @put('/voter-register-users/{id}')
  @response(204, {
    description: 'VoterRegisterUsers PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() voterRegisterUsers: VoterRegisterUsers,
  ): Promise<void> {
    await this.voterRegisterUsersRepository.replaceById(id, voterRegisterUsers);
  }

  @del('/voter-register-users/{id}')
  @response(204, {
    description: 'VoterRegisterUsers DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.voterRegisterUsersRepository.deleteById(id);
  }
}
