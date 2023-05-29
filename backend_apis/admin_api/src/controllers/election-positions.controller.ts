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
import {ElectionPositions} from '../models';
import {ElectionPositionsRepository} from '../repositories';

export class ElectionPositionsController {
  constructor(
    @repository(ElectionPositionsRepository)
    public electionPositionsRepository : ElectionPositionsRepository,
  ) {}

  @post('/election-positions')
  @response(200, {
    description: 'ElectionPositions model instance',
    content: {'application/json': {schema: getModelSchemaRef(ElectionPositions)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(ElectionPositions, {
            title: 'NewElectionPositions',
            exclude: ['positionId'],
          }),
        },
      },
    })
    electionPositions: Omit<ElectionPositions, 'positionId'>,
  ): Promise<ElectionPositions> {
    return this.electionPositionsRepository.create(electionPositions);
  }

  @get('/election-positions/count')
  @response(200, {
    description: 'ElectionPositions model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(ElectionPositions) where?: Where<ElectionPositions>,
  ): Promise<Count> {
    return this.electionPositionsRepository.count(where);
  }

  @get('/election-positions')
  @response(200, {
    description: 'Array of ElectionPositions model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(ElectionPositions, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(ElectionPositions) filter?: Filter<ElectionPositions>,
  ): Promise<ElectionPositions[]> {
    return this.electionPositionsRepository.find(filter);
  }

  @patch('/election-positions')
  @response(200, {
    description: 'ElectionPositions PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(ElectionPositions, {partial: true}),
        },
      },
    })
    electionPositions: ElectionPositions,
    @param.where(ElectionPositions) where?: Where<ElectionPositions>,
  ): Promise<Count> {
    return this.electionPositionsRepository.updateAll(electionPositions, where);
  }

  @get('/election-positions/{id}')
  @response(200, {
    description: 'ElectionPositions model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(ElectionPositions, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(ElectionPositions, {exclude: 'where'}) filter?: FilterExcludingWhere<ElectionPositions>
  ): Promise<ElectionPositions> {
    return this.electionPositionsRepository.findById(id, filter);
  }

  @patch('/election-positions/{id}')
  @response(204, {
    description: 'ElectionPositions PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(ElectionPositions, {partial: true}),
        },
      },
    })
    electionPositions: ElectionPositions,
  ): Promise<void> {
    await this.electionPositionsRepository.updateById(id, electionPositions);
  }

  @put('/election-positions/{id}')
  @response(204, {
    description: 'ElectionPositions PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() electionPositions: ElectionPositions,
  ): Promise<void> {
    await this.electionPositionsRepository.replaceById(id, electionPositions);
  }

  @del('/election-positions/{id}')
  @response(204, {
    description: 'ElectionPositions DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.electionPositionsRepository.deleteById(id);
  }
}
