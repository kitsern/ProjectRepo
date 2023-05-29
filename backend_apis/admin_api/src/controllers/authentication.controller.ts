// Uncomment these imports to begin using these cool features!

// import {inject} from '@loopback/core';
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
import {AdminUsers, UserCredentials} from '../models';
import {AdminUsersRepository, UserCredentialsRepository} from '../repositories';

export class AuthenticationController {
  constructor(
    @repository(AdminUsersRepository)
    public adminUsersRepository : AdminUsersRepository,
    @repository(UserCredentialsRepository)
    public userCredentialsRepository : UserCredentialsRepository,
  ) {}

  @post('/auth/login')
  @response(200, {
    description: 'Authenticated User Information',
    content: {
        'application/json': {schema: getModelSchemaRef(AdminUsers)}
      },
  })
  async login(
    @requestBody({
      content: {
        'application/json': {
          schema: {
            username:{
              type: "string"
            },
            password:{
              type: 'string'
            }
          }
        },
      },
    })
    adminUsers: AdminUsers,
  ): Promise<AdminUsers> {
    
    return this.adminUsersRepository.create(adminUsers);
  }
}
