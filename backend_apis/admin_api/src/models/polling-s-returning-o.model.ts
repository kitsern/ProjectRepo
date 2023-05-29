import {Entity, model, property} from '@loopback/repository';

@model({
  settings: {
    idInjection: false,
    postgresql: {schema: 'evoting', table: 'polling_s_returning_o'}
  }
})
export class PollingSReturningO extends Entity {
  @property({
    type: 'date',
    
    postgresql: {columnName: 'sdate', dataType: 'timestamp with time zone', dataLength: null, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  sdate?: string;

  @property({
    type: 'string',
    
    length: 50,
    
    id: 1,
    postgresql: {columnName: 'returning_officer_id', dataType: 'character varying', dataLength: 50, dataPrecision: null, dataScale: null, nullable: 'NO', generated: undefined},
  })
  returningOfficerId: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'station_id', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  stationId?: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'user_id', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  userId?: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'election_id', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  electionId?: string;

  // Define well-known properties here

  // Indexer property to allow additional data
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [prop: string]: any;

  constructor(data?: Partial<PollingSReturningO>) {
    super(data);
  }
}

export interface PollingSReturningORelations {
  // describe navigational properties here
}

export type PollingSReturningOWithRelations = PollingSReturningO & PollingSReturningORelations;
