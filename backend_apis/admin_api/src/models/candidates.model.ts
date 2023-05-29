import {Entity, model, property} from '@loopback/repository';

@model({
  settings: {idInjection: false, postgresql: {schema: 'evoting', table: 'candidates'}}
})
export class Candidates extends Entity {

  @property({
    type: 'date',
    postgresql: {columnName: 'sdate', dataType: 'timestamp with time zone', dataLength: null, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  sdate?: string;

  @property({
    type: 'string',
    length: 50,
    id: 1,
    postgresql: {columnName: 'candidate_id', dataType: 'character varying', dataLength: 50, dataPrecision: null, dataScale: null, nullable: 'NO', generated: undefined},
  })
  candidateId: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'user_id', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  userId?: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'position_id', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  positionId?: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'candidate_slogan', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  candidateSlogan?: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'candidate_symbol', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  candidateSymbol?: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'candidate_color', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  candidateColor?: string;

  @property({
    type: 'object',
    
    postgresql: {columnName: 'other_info', dataType: 'jsonb', dataLength: null, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  otherInfo?: object;

  @property({
    type: 'object',
    
    postgresql: {columnName: 'tags', dataType: 'jsonb', dataLength: null, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  tags?: object;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'created_by', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  createdBy?: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'last_updated_by', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  lastUpdatedBy?: string;

  @property({
    type: 'date',
    
    postgresql: {columnName: 'last_updated_date', dataType: 'timestamp with time zone', dataLength: null, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  lastUpdatedDate?: string;

  @property({
    type: 'string',
    length: 1,
    
    postgresql: {columnName: 'locked', dataType: 'character varying', dataLength: 1, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  locked?: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'locked_by', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  lockedBy?: string;

  @property({
    type: 'date',
    
    postgresql: {columnName: 'locked_date', dataType: 'timestamp with time zone', dataLength: null, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  lockedDate?: string;

  @property({
    type: 'number',
    
    postgresql: {columnName: 'object_vsn', dataType: 'numeric', dataLength: null, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  objectVsn?: number;

  @property({
    type: 'string',
    length: 1,
    
    postgresql: {columnName: 'archived', dataType: 'character varying', dataLength: 1, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  archived?: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'archived_by', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  archivedBy?: string;

  @property({
    type: 'date',
    
    postgresql: {columnName: 'archived_date', dataType: 'timestamp with time zone', dataLength: null, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  archivedDate?: string;

  @property({
    type: 'string',
    length: 1,
    
    postgresql: {columnName: 'deleted', dataType: 'character varying', dataLength: 1, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  deleted?: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'deleted_by', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  deletedBy?: string;

  @property({
    type: 'date',
    
    postgresql: {columnName: 'deleted_date', dataType: 'timestamp with time zone', dataLength: null, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  deletedDate?: string;

  // Define well-known properties here

  // Indexer property to allow additional data
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [prop: string]: any;

  constructor(data?: Partial<Candidates>) {
    super(data);
  }
}

export interface CandidatesRelations {
  // describe navigational properties here
}

export type CandidatesWithRelations = Candidates & CandidatesRelations;
