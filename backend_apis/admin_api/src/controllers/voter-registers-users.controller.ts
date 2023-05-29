import {
  Count,
  CountSchema,
  Filter,
  repository,
  Where,
} from '@loopback/repository';
  import {
  del,
  get,
  getModelSchemaRef,
  getWhereSchemaFor,
  param,
  patch,
  post,
  requestBody,
} from '@loopback/rest';
import {
VoterRegisters,
VoterRegisterUsers,
Users,
} from '../models';
import {VoterRegistersRepository} from '../repositories';

export class VoterRegistersUsersController {
  constructor(
    @repository(VoterRegistersRepository) protected voterRegistersRepository: VoterRegistersRepository,
  ) { }

  @get('/voter-registers/{id}/users', {
    responses: {
      '200': {
        description: 'Array of VoterRegisters has many Users through VoterRegisterUsers',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(Users)},
          },
        },
      },
    },
  })
  async find(
    @param.path.string('id') id: string,
    @param.query.object('filter') filter?: Filter<Users>,
  ): Promise<Users[]> {
    return this.voterRegistersRepository.users(id).find(filter);
  }

  @post('/voter-registers/{id}/users', {
    responses: {
      '200': {
        description: 'create a Users model instance',
        content: {'application/json': {schema: getModelSchemaRef(Users)}},
      },
    },
  })
  async create(
    @param.path.string('id') id: typeof VoterRegisters.prototype.registerId,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Users, {
            title: 'NewUsersInVoterRegisters',
            exclude: ['userId'],
          }),
        },
      },
    }) users: Omit<Users, 'userId'>,
  ): Promise<Users> {
    return this.voterRegistersRepository.users(id).create(users);
  }

  @patch('/voter-registers/{id}/users', {
    responses: {
      '200': {
        description: 'VoterRegisters.Users PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async patch(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Users, {partial: true}),
        },
      },
    })
    users: Partial<Users>,
    @param.query.object('where', getWhereSchemaFor(Users)) where?: Where<Users>,
  ): Promise<Count> {
    return this.voterRegistersRepository.users(id).patch(users, where);
  }

  @del('/voter-registers/{id}/users', {
    responses: {
      '200': {
        description: 'VoterRegisters.Users DELETE success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async delete(
    @param.path.string('id') id: string,
    @param.query.object('where', getWhereSchemaFor(Users)) where?: Where<Users>,
  ): Promise<Count> {
    return this.voterRegistersRepository.users(id).delete(where);
  }
}
