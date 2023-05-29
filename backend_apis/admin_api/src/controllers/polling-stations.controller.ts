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
import {PollingStations} from '../models';
import {PollingStationsRepository} from '../repositories';

export class PollingStationsController {
  constructor(
    @repository(PollingStationsRepository)
    public pollingStationsRepository : PollingStationsRepository,
  ) {}

  @post('/polling-stations')
  @response(200, {
    description: 'PollingStations model instance',
    content: {'application/json': {schema: getModelSchemaRef(PollingStations)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PollingStations, {
            title: 'NewPollingStations',
            exclude: ['stationId'],
          }),
        },
      },
    })
    pollingStations: Omit<PollingStations, 'stationId'>,
  ): Promise<PollingStations> {
    return this.pollingStationsRepository.create(pollingStations);
  }

  @get('/polling-stations/count')
  @response(200, {
    description: 'PollingStations model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(PollingStations) where?: Where<PollingStations>,
  ): Promise<Count> {
    return this.pollingStationsRepository.count(where);
  }

  @get('/polling-stations')
  @response(200, {
    description: 'Array of PollingStations model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(PollingStations, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(PollingStations) filter?: Filter<PollingStations>,
  ): Promise<PollingStations[]> {
    return this.pollingStationsRepository.find(filter);
  }

  @patch('/polling-stations')
  @response(200, {
    description: 'PollingStations PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PollingStations, {partial: true}),
        },
      },
    })
    pollingStations: PollingStations,
    @param.where(PollingStations) where?: Where<PollingStations>,
  ): Promise<Count> {
    return this.pollingStationsRepository.updateAll(pollingStations, where);
  }

  @get('/polling-stations/{id}')
  @response(200, {
    description: 'PollingStations model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(PollingStations, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(PollingStations, {exclude: 'where'}) filter?: FilterExcludingWhere<PollingStations>
  ): Promise<PollingStations> {
    return this.pollingStationsRepository.findById(id, filter);
  }

  @patch('/polling-stations/{id}')
  @response(204, {
    description: 'PollingStations PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PollingStations, {partial: true}),
        },
      },
    })
    pollingStations: PollingStations,
  ): Promise<void> {
    await this.pollingStationsRepository.updateById(id, pollingStations);
  }

  @put('/polling-stations/{id}')
  @response(204, {
    description: 'PollingStations PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() pollingStations: PollingStations,
  ): Promise<void> {
    await this.pollingStationsRepository.replaceById(id, pollingStations);
  }

  @del('/polling-stations/{id}')
  @response(204, {
    description: 'PollingStations DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.pollingStationsRepository.deleteById(id);
  }
}
