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
import {ElectionInstances} from '../models';
import {ElectionInstancesRepository} from '../repositories';

export class ElectionsController {
  constructor(
    @repository(ElectionInstancesRepository)
    public electionInstancesRepository : ElectionInstancesRepository,
  ) {}

  @post('/election-instances')
  @response(200, {
    description: 'ElectionInstances model instance',
    content: {'application/json': {schema: getModelSchemaRef(ElectionInstances)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(ElectionInstances, {
            title: 'NewElectionInstances',
            exclude: ['electionId'],
          }),
        },
      },
    })
    electionInstances: Omit<ElectionInstances, 'electionId'>,
  ): Promise<ElectionInstances> {
    return this.electionInstancesRepository.create(electionInstances);
  }

  @get('/election-instances/count')
  @response(200, {
    description: 'ElectionInstances model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(ElectionInstances) where?: Where<ElectionInstances>,
  ): Promise<Count> {
    return this.electionInstancesRepository.count(where);
  }

  @get('/election-instances')
  @response(200, {
    description: 'Array of ElectionInstances model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(ElectionInstances, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(ElectionInstances) filter?: Filter<ElectionInstances>,
  ): Promise<ElectionInstances[]> {
    return this.electionInstancesRepository.find(filter);
  }

  @patch('/election-instances')
  @response(200, {
    description: 'ElectionInstances PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(ElectionInstances, {partial: true}),
        },
      },
    })
    electionInstances: ElectionInstances,
    @param.where(ElectionInstances) where?: Where<ElectionInstances>,
  ): Promise<Count> {
    return this.electionInstancesRepository.updateAll(electionInstances, where);
  }

  @get('/election-instances/{id}')
  @response(200, {
    description: 'ElectionInstances model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(ElectionInstances, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(ElectionInstances, {exclude: 'where'}) filter?: FilterExcludingWhere<ElectionInstances>
  ): Promise<ElectionInstances> {
    return this.electionInstancesRepository.findById(id, filter);
  }

  @patch('/election-instances/{id}')
  @response(204, {
    description: 'ElectionInstances PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(ElectionInstances, {partial: true}),
        },
      },
    })
    electionInstances: ElectionInstances,
  ): Promise<void> {
    await this.electionInstancesRepository.updateById(id, electionInstances);
  }

  @put('/election-instances/{id}')
  @response(204, {
    description: 'ElectionInstances PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() electionInstances: ElectionInstances,
  ): Promise<void> {
    await this.electionInstancesRepository.replaceById(id, electionInstances);
  }

  @del('/election-instances/{id}')
  @response(204, {
    description: 'ElectionInstances DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.electionInstancesRepository.deleteById(id);
  }
}
