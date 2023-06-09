/*
 * File: app/view/NewUser.js
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

Ext.define('Admin.view.NewUser', {
    extend: 'Ext.form.Panel',
    alias: 'widget.newuser',

    requires: [
        'Admin.view.NewElectionViewModel2',
        'Ext.form.field.Text',
        'Ext.button.Button'
    ],

    viewModel: {
        type: 'newuser'
    },
    width: 466,
    bodyPadding: 10,
    title: 'New Register',

    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    items: [
        {
            xtype: 'textfield',
            fieldLabel: 'First Name',
            name: 'firstName',
            allowBlank: false
        },
        {
            xtype: 'textfield',
            fieldLabel: 'Other Names',
            name: 'otherNames',
            allowBlank: false
        },
        {
            xtype: 'textfield',
            fieldLabel: 'Gender',
            name: 'gender',
            allowBlank: false
        },
        {
            xtype: 'textfield',
            fieldLabel: 'Telno',
            name: 'smsTelno',
            allowBlank: false
        },
        {
            xtype: 'button',
            handler: function(button, e) {
                var form = button.up('form').getForm();


                if(form.isValid()){
                    var data = form.getValues();
                    let name = data.firstName +'_'+ data.otherNames;
                    data.username = name.toLowerCase().split(' ').join('_');

                    axios.post(`${config.ADMIN_API}/users`,data).then(response=>{
                    console.log(response);
                    let {data, status} = response;
                    if(data&& status==200){

                        Ext.toast('User Created !!!');
                        button.up('form').close();
                        Ext.getStore('UserStore').load();

                    }else{
                        Ext.Msg.alert('Error','Unable to create User');
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
            text: 'Add User'
        }
    ]

});