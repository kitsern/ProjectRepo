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
import {VoterRegisters} from '../models';
import {VoterRegistersRepository} from '../repositories';

export class VoterRegistersController {
  constructor(
    @repository(VoterRegistersRepository)
    public voterRegistersRepository : VoterRegistersRepository,
  ) {}

  @post('/voter-registers')
  @response(200, {
    description: 'VoterRegisters model instance',
    content: {'application/json': {schema: getModelSchemaRef(VoterRegisters)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(VoterRegisters, {
            title: 'NewVoterRegisters',
            exclude: ['registerId'],
          }),
        },
      },
    })
    voterRegisters: Omit<VoterRegisters, 'registerId'>,
  ): Promise<VoterRegisters> {
    return this.voterRegistersRepository.create(voterRegisters);
  }

  @get('/voter-registers/count')
  @response(200, {
    description: 'VoterRegisters model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(VoterRegisters) where?: Where<VoterRegisters>,
  ): Promise<Count> {
    return this.voterRegistersRepository.count(where);
  }

  @get('/voter-registers')
  @response(200, {
    description: 'Array of VoterRegisters model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(VoterRegisters, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(VoterRegisters) filter?: Filter<VoterRegisters>,
  ): Promise<VoterRegisters[]> {
    return this.voterRegistersRepository.find(filter);
  }

  @patch('/voter-registers')
  @response(200, {
    description: 'VoterRegisters PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(VoterRegisters, {partial: true}),
        },
      },
    })
    voterRegisters: VoterRegisters,
    @param.where(VoterRegisters) where?: Where<VoterRegisters>,
  ): Promise<Count> {
    return this.voterRegistersRepository.updateAll(voterRegisters, where);
  }

  @get('/voter-registers/{id}')
  @response(200, {
    description: 'VoterRegisters model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(VoterRegisters, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(VoterRegisters, {exclude: 'where'}) filter?: FilterExcludingWhere<VoterRegisters>
  ): Promise<VoterRegisters> {
    return this.voterRegistersRepository.findById(id, filter);
  }

  @patch('/voter-registers/{id}')
  @response(204, {
    description: 'VoterRegisters PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(VoterRegisters, {partial: true}),
        },
      },
    })
    voterRegisters: VoterRegisters,
  ): Promise<void> {
    await this.voterRegistersRepository.updateById(id, voterRegisters);
  }

  @put('/voter-registers/{id}')
  @response(204, {
    description: 'VoterRegisters PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() voterRegisters: VoterRegisters,
  ): Promise<void> {
    await this.voterRegistersRepository.replaceById(id, voterRegisters);
  }

  @del('/voter-registers/{id}')
  @response(204, {
    description: 'VoterRegisters DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.voterRegistersRepository.deleteById(id);
  }
}
