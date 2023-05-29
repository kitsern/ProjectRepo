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
import {Votes} from '../models';
import {VotesRepository} from '../repositories';

export class VotesController {
  constructor(
    @repository(VotesRepository)
    public votesRepository : VotesRepository,
  ) {}

  @post('/votes')
  @response(200, {
    description: 'Votes model instance',
    content: {'application/json': {schema: getModelSchemaRef(Votes)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Votes, {
            title: 'NewVotes',
            exclude: ['voteId'],
          }),
        },
      },
    })
    votes: Omit<Votes, 'voteId'>,
  ): Promise<Votes> {
    return this.votesRepository.create(votes);
  }

  @get('/votes/count')
  @response(200, {
    description: 'Votes model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(Votes) where?: Where<Votes>,
  ): Promise<Count> {
    return this.votesRepository.count(where);
  }

  @get('/votes')
  @response(200, {
    description: 'Array of Votes model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(Votes, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(Votes) filter?: Filter<Votes>,
  ): Promise<Votes[]> {
    return this.votesRepository.find(filter);
  }

  @patch('/votes')
  @response(200, {
    description: 'Votes PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Votes, {partial: true}),
        },
      },
    })
    votes: Votes,
    @param.where(Votes) where?: Where<Votes>,
  ): Promise<Count> {
    return this.votesRepository.updateAll(votes, where);
  }

  @get('/votes/{id}')
  @response(200, {
    description: 'Votes model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(Votes, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(Votes, {exclude: 'where'}) filter?: FilterExcludingWhere<Votes>
  ): Promise<Votes> {
    return this.votesRepository.findById(id, filter);
  }

  @patch('/votes/{id}')
  @response(204, {
    description: 'Votes PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Votes, {partial: true}),
        },
      },
    })
    votes: Votes,
  ): Promise<void> {
    await this.votesRepository.updateById(id, votes);
  }

  @put('/votes/{id}')
  @response(204, {
    description: 'Votes PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() votes: Votes,
  ): Promise<void> {
    await this.votesRepository.replaceById(id, votes);
  }

  @del('/votes/{id}')
  @response(204, {
    description: 'Votes DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.votesRepository.deleteById(id);
  }
}
