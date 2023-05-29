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
import {Candidates} from '../models';
import {CandidatesRepository} from '../repositories';

export class CandidatesController {
  constructor(
    @repository(CandidatesRepository)
    public candidatesRepository : CandidatesRepository,
  ) {}

  @post('/candidates')
  @response(200, {
    description: 'Candidates model instance',
    content: {'application/json': {schema: getModelSchemaRef(Candidates)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Candidates, {
            title: 'NewCandidates',
            exclude: ['candidate_id'],
          }),
        },
      },
    })
    candidates: Omit<Candidates, 'candidate_id'>,
  ): Promise<Candidates> {
    return this.candidatesRepository.create(candidates);
  }

  @get('/candidates/count')
  @response(200, {
    description: 'Candidates model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(Candidates) where?: Where<Candidates>,
  ): Promise<Count> {
    return this.candidatesRepository.count(where);
  }

  @get('/candidates')
  @response(200, {
    description: 'Array of Candidates model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(Candidates, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(Candidates) filter?: Filter<Candidates>,
  ): Promise<Candidates[]> {
    return this.candidatesRepository.find(filter);
  }

  @patch('/candidates')
  @response(200, {
    description: 'Candidates PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Candidates, {partial: true}),
        },
      },
    })
    candidates: Candidates,
    @param.where(Candidates) where?: Where<Candidates>,
  ): Promise<Count> {
    return this.candidatesRepository.updateAll(candidates, where);
  }

  @get('/candidates/{id}')
  @response(200, {
    description: 'Candidates model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(Candidates, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(Candidates, {exclude: 'where'}) filter?: FilterExcludingWhere<Candidates>
  ): Promise<Candidates> {
    return this.candidatesRepository.findById(id, filter);
  }

  @patch('/candidates/{id}')
  @response(204, {
    description: 'Candidates PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Candidates, {partial: true}),
        },
      },
    })
    candidates: Candidates,
  ): Promise<void> {
    await this.candidatesRepository.updateById(id, candidates);
  }

  @put('/candidates/{id}')
  @response(204, {
    description: 'Candidates PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() candidates: Candidates,
  ): Promise<void> {
    await this.candidatesRepository.replaceById(id, candidates);
  }

  @del('/candidates/{id}')
  @response(204, {
    description: 'Candidates DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.candidatesRepository.deleteById(id);
  }
}
