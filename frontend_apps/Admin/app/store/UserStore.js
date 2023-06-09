/*
 * File: app/store/UserStore.js
 *
 * This file was generated by Sencha Architect version 4.2.9.
 * http://www.sencha.com/products/architect/
 *
 * This file requires use of the Ext JS 7.3.x Classic library, under independent license.
 * License of Sencha Architect does not include license for Ext JS 7.3.x Classic. For more
 * details see http://www.sencha.com/license or contact license@sencha.com.
 *
 * This file will be auto-generated each and everytime you save your project.
 *
 * Do NOT hand edit this file.
 */

Ext.define('Admin.store.UserStore', {
    extend: 'Ext.data.Store',

    requires: [
        'Ext.data.field.Field',
        'Ext.data.proxy.Ajax'
    ],

    constructor: function(cfg) {
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            storeId: 'UserStore',
            autoLoad: true,
            fields: [
                {
                    name: 'userId'
                },
                {
                    name: 'firstName'
                },
                {
                    name: 'otherNames'
                },
                {
                    name: 'smsmTelno'
                },
                {
                    name: 'username'
                }
            ],
            proxy: {
                type: 'ajax',
                url: 'http://localhost:3000/users'
            }
        }, cfg)]);
    }
});