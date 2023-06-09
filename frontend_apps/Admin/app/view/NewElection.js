/*
 * File: app/view/NewElection.js
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

Ext.define('Admin.view.NewElection', {
    extend: 'Ext.form.Panel',
    alias: 'widget.newelection',

    requires: [
        'Admin.view.NewElectionViewModel',
        'Admin.view.NewElectionViewController',
        'Ext.form.field.TextArea',
        'Ext.form.field.Date',
        'Ext.form.field.Time',
        'Ext.button.Button'
    ],

    controller: 'newelection',
    viewModel: {
        type: 'newelection'
    },
    width: 466,
    bodyPadding: 10,
    title: 'New Election',

    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    items: [
        {
            xtype: 'textfield',
            fieldLabel: 'Name',
            name: 'electionName',
            allowBlank: false
        },
        {
            xtype: 'textareafield',
            fieldLabel: 'Description',
            name: 'electionDescription',
            allowBlank: false
        },
        {
            xtype: 'datefield',
            fieldLabel: 'Start  Date',
            name: 'start',
            allowBlank: false,
            format: 'd-m-y',
            listeners: {
                afterrender: 'onDatefieldAfterRender',
                select: 'onDatefieldSelect'
            }
        },
        {
            xtype: 'datefield',
            disabled: true,
            fieldLabel: 'End  Date',
            name: 'end',
            allowBlank: false,
            format: 'd-m-y'
        },
        {
            xtype: 'timefield',
            flex: 1,
            itemId: 'start_time',
            fieldLabel: 'Start Time',
            name: 'start_time',
            allowBlank: false
        },
        {
            xtype: 'timefield',
            flex: 1,
            itemId: 'end_time',
            fieldLabel: 'End Time',
            name: 'end_time',
            allowBlank: false
        },
        {
            xtype: 'button',
            handler: function(button, e) {
                var form = button.up('form').getForm();

                function formatter(date, time){
                    var newFormat = `${date.split('-')[1]}-${date.split('-')[0]}-${date.split('-')[2]}`;
                    var dateObj = new Date(newFormat);

                    dateObj =  new Date(dateObj.setHours(time.hours));
                    dateObj = new Date(dateObj.setMinutes(time.minutes));
                    return dateObj.toISOString();

                }
                if(form.isValid()){
                    var data = form.getValues();
                    start_time = button.up('newelection').down('#start_time').getValue();
                    var end_time = button.up('newelection').down('#end_time').getValue();


                    data.electionStartDate = formatter(data.start,{
                        hours:start_time.getHours(),
                        minutes:start_time.getMinutes()
                    });
                    data.electionEndDate  = formatter(data.end,{
                        hours:end_time.getHours(),
                        minutes:end_time.getMinutes()
                    });
                    delete data.start;
                    delete data.end;
                    delete data.start_time;
                    delete data.end_time;

                    axios.post(`${config.ADMIN_API}/election-instances`,data).then(response=>{
                    console.log(response);
                    let {data, status} = response;
                    if(data&& status==200){

                        Ext.toast('Election Created !!!');
                        button.up('form').close();
                        Ext.getStore('ElectionsStore').load();

                    }else{
                        Ext.Msg.alert('Error','Unable to create Election');
                    }

                }).catch(error=>{
                    Ext.Msg.alert('Error','Unable to create User');
                });


            }else{
                Ext.toast('Please Enter All Required Fields');
            }
            },
            height: 45,
            style: 'border-radius:4px;',
            text: 'Add Election Instance'
        }
    ]

});