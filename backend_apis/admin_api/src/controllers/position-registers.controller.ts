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
import {PositionRegisters} from '../models';
import {PositionRegistersRepository} from '../repositories';

export class PositionRegistersController {
  constructor(
    @repository(PositionRegistersRepository)
    public positionRegistersRepository : PositionRegistersRepository,
  ) {}

  @post('/position-registers')
  @response(200, {
    description: 'PositionRegisters model instance',
    content: {'application/json': {schema: getModelSchemaRef(PositionRegisters)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PositionRegisters, {
            title: 'NewPositionRegisters',
            exclude: ['registerId'],
          }),
        },
      },
    })
    positionRegisters: Omit<PositionRegisters, 'registerId'>,
  ): Promise<PositionRegisters> {
    return this.positionRegistersRepository.create(positionRegisters);
  }

  @get('/position-registers/count')
  @response(200, {
    description: 'PositionRegisters model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(PositionRegisters) where?: Where<PositionRegisters>,
  ): Promise<Count> {
    return this.positionRegistersRepository.count(where);
  }

  @get('/position-registers')
  @response(200, {
    description: 'Array of PositionRegisters model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(PositionRegisters, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(PositionRegisters) filter?: Filter<PositionRegisters>,
  ): Promise<PositionRegisters[]> {
    return this.positionRegistersRepository.find(filter);
  }

  @patch('/position-registers')
  @response(200, {
    description: 'PositionRegisters PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PositionRegisters, {partial: true}),
        },
      },
    })
    positionRegisters: PositionRegisters,
    @param.where(PositionRegisters) where?: Where<PositionRegisters>,
  ): Promise<Count> {
    return this.positionRegistersRepository.updateAll(positionRegisters, where);
  }

  @get('/position-registers/{id}')
  @response(200, {
    description: 'PositionRegisters model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(PositionRegisters, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(PositionRegisters, {exclude: 'where'}) filter?: FilterExcludingWhere<PositionRegisters>
  ): Promise<PositionRegisters> {
    return this.positionRegistersRepository.findById(id, filter);
  }

  @patch('/position-registers/{id}')
  @response(204, {
    description: 'PositionRegisters PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PositionRegisters, {partial: true}),
        },
      },
    })
    positionRegisters: PositionRegisters,
  ): Promise<void> {
    await this.positionRegistersRepository.updateById(id, positionRegisters);
  }

  @put('/position-registers/{id}')
  @response(204, {
    description: 'PositionRegisters PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() positionRegisters: PositionRegisters,
  ): Promise<void> {
    await this.positionRegistersRepository.replaceById(id, positionRegisters);
  }

  @del('/position-registers/{id}')
  @response(204, {
    description: 'PositionRegisters DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.positionRegistersRepository.deleteById(id);
  }
}
