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
import {PollingSReturningO} from '../models';
import {PollingSReturningORepository} from '../repositories';

export class ReturningOfficersController {
  constructor(
    @repository(PollingSReturningORepository)
    public pollingSReturningORepository : PollingSReturningORepository,
  ) {}

  @post('/polling-s-returning-os')
  @response(200, {
    description: 'PollingSReturningO model instance',
    content: {'application/json': {schema: getModelSchemaRef(PollingSReturningO)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PollingSReturningO, {
            title: 'NewPollingSReturningO',
            exclude: ['returningOfficerId'],
          }),
        },
      },
    })
    pollingSReturningO: Omit<PollingSReturningO, 'returningOfficerId'>,
  ): Promise<PollingSReturningO> {
    return this.pollingSReturningORepository.create(pollingSReturningO);
  }

  @get('/polling-s-returning-os/count')
  @response(200, {
    description: 'PollingSReturningO model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(PollingSReturningO) where?: Where<PollingSReturningO>,
  ): Promise<Count> {
    return this.pollingSReturningORepository.count(where);
  }

  @get('/polling-s-returning-os')
  @response(200, {
    description: 'Array of PollingSReturningO model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(PollingSReturningO, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(PollingSReturningO) filter?: Filter<PollingSReturningO>,
  ): Promise<PollingSReturningO[]> {
    return this.pollingSReturningORepository.find(filter);
  }

  @patch('/polling-s-returning-os')
  @response(200, {
    description: 'PollingSReturningO PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PollingSReturningO, {partial: true}),
        },
      },
    })
    pollingSReturningO: PollingSReturningO,
    @param.where(PollingSReturningO) where?: Where<PollingSReturningO>,
  ): Promise<Count> {
    return this.pollingSReturningORepository.updateAll(pollingSReturningO, where);
  }

  @get('/polling-s-returning-os/{id}')
  @response(200, {
    description: 'PollingSReturningO model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(PollingSReturningO, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(PollingSReturningO, {exclude: 'where'}) filter?: FilterExcludingWhere<PollingSReturningO>
  ): Promise<PollingSReturningO> {
    return this.pollingSReturningORepository.findById(id, filter);
  }

  @patch('/polling-s-returning-os/{id}')
  @response(204, {
    description: 'PollingSReturningO PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PollingSReturningO, {partial: true}),
        },
      },
    })
    pollingSReturningO: PollingSReturningO,
  ): Promise<void> {
    await this.pollingSReturningORepository.updateById(id, pollingSReturningO);
  }

  @put('/polling-s-returning-os/{id}')
  @response(204, {
    description: 'PollingSReturningO PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() pollingSReturningO: PollingSReturningO,
  ): Promise<void> {
    await this.pollingSReturningORepository.replaceById(id, pollingSReturningO);
  }

  @del('/polling-s-returning-os/{id}')
  @response(204, {
    description: 'PollingSReturningO DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.pollingSReturningORepository.deleteById(id);
  }
}
