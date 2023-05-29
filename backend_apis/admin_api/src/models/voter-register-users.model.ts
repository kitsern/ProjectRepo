import {Entity, model, property} from '@loopback/repository';

@model({
  settings: {
    idInjection: false,
    postgresql: {schema: 'evoting', table: 'voter_register_users'}
  }
})
export class VoterRegisterUsers extends Entity {
  @property({
    type: 'date',

    postgresql: {columnName: 'sdate', dataType: 'timestamp with time zone', dataLength: null, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  sdate?: string;

  @property({
    type: 'string',
    length: 50,

    id: 1,
    postgresql: {columnName: 'voter_user_id', dataType: 'character varying', dataLength: 50, dataPrecision: null, dataScale: null, nullable: 'NO', generated: undefined},
  })
  voterUserId: string;

  @property({
    type: 'string',
    length: 100,

    postgresql: {columnName: 'user_id', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  userId?: string;

  @property({
    type: 'string',
    length: 100,

    postgresql: {columnName: 'register_id', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  registerId?: string;

  @property({
    type: 'string',
  })
  voterRegistersId?: string;

  @property({
    type: 'string',
  })
  usersId?: string;
  // Define well-known properties here

  // Indexer property to allow additional data
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [prop: string]: any;

  constructor(data?: Partial<VoterRegisterUsers>) {
    super(data);
  }
}

export interface VoterRegisterUsersRelations {
  // describe navigational properties here
}

export type VoterRegisterUsersWithRelations = VoterRegisterUsers & VoterRegisterUsersRelations;
