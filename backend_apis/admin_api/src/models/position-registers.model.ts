import {Entity, model, property} from '@loopback/repository';

@model({
  settings: {
    idInjection: false,
    postgresql: {schema: 'evoting', table: 'position_registers'}
  }
})
export class PositionRegisters extends Entity {
  @property({
    type: 'date',
    
    postgresql: {columnName: 'sdate', dataType: 'timestamp with time zone', dataLength: null, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  sdate?: string;

  @property({
    type: 'string',
  
    length: 50,
    
    id: 1,
    postgresql: {columnName: 'position_register_id', dataType: 'character varying', dataLength: 50, dataPrecision: null, dataScale: null, nullable: 'NO', generated: undefined},
  })
  positionRegisterId: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'position_id', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  positionId?: string;

  @property({
    type: 'string',
    length: 100,
    
    postgresql: {columnName: 'register_id', dataType: 'character varying', dataLength: 100, dataPrecision: null, dataScale: null, nullable: 'YES', generated: undefined},
  })
  registerId?: string;

  // Define well-known properties here

  // Indexer property to allow additional data
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [prop: string]: any;

  constructor(data?: Partial<PositionRegisters>) {
    super(data);
  }
}

export interface PositionRegistersRelations {
  // describe navigational properties here
}

export type PositionRegistersWithRelations = PositionRegisters & PositionRegistersRelations;
