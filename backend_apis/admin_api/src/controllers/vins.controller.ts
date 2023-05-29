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
import {Vins} from '../models';
import {VinsRepository} from '../repositories';

export class VinsController {
  constructor(
    @repository(VinsRepository)
    public vinsRepository : VinsRepository,
  ) {}

  @post('/vins')
  @response(200, {
    description: 'Vins model instance',
    content: {'application/json': {schema: getModelSchemaRef(Vins)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Vins, {
            title: 'NewVins',
            exclude: ['vinId'],
          }),
        },
      },
    })
    vins: Omit<Vins, 'vinId'>,
  ): Promise<Vins> {
    return this.vinsRepository.create(vins);
  }

  @get('/vins/count')
  @response(200, {
    description: 'Vins model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(Vins) where?: Where<Vins>,
  ): Promise<Count> {
    return this.vinsRepository.count(where);
  }

  @get('/vins')
  @response(200, {
    description: 'Array of Vins model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(Vins, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(Vins) filter?: Filter<Vins>,
  ): Promise<Vins[]> {
    return this.vinsRepository.find(filter);
  }

  @patch('/vins')
  @response(200, {
    description: 'Vins PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Vins, {partial: true}),
        },
      },
    })
    vins: Vins,
    @param.where(Vins) where?: Where<Vins>,
  ): Promise<Count> {
    return this.vinsRepository.updateAll(vins, where);
  }

  @get('/vins/{id}')
  @response(200, {
    description: 'Vins model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(Vins, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(Vins, {exclude: 'where'}) filter?: FilterExcludingWhere<Vins>
  ): Promise<Vins> {
    return this.vinsRepository.findById(id, filter);
  }

  @patch('/vins/{id}')
  @response(204, {
    description: 'Vins PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Vins, {partial: true}),
        },
      },
    })
    vins: Vins,
  ): Promise<void> {
    await this.vinsRepository.updateById(id, vins);
  }

  @put('/vins/{id}')
  @response(204, {
    description: 'Vins PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() vins: Vins,
  ): Promise<void> {
    await this.vinsRepository.replaceById(id, vins);
  }

  @del('/vins/{id}')
  @response(204, {
    description: 'Vins DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.vinsRepository.deleteById(id);
  }
}
