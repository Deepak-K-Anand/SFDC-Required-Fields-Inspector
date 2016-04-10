angular.module( "reqFieldsInspectApp", [] ).controller(
    "ReqFieldsInspectCtrl",
    [
        "$scope",
        function( $scope ) {
            var self                    = this;
            this.processing             = true;
            this.sObjects               = [];
            this.requiredFields         = {};
            this.requiredFieldsShown    = false;
            this.requiredOnPageLayouts  = [];
            this.components             = {
                select : {
                    initialize : function() {
                        jQuery( "#sObjectsList" ).selectize();
                    }
                }
            };
            
            this.showProgress = function( isShown ) {
                this.processing = isShown;
            };
            
            this.showRequiredFields = function( isShown ) {
                this.requiredFieldsShown = isShown;
            };
            
            this.fetchSObjects = function() {
                this.showProgress( true );
                        
                sforce.connection.describeGlobal(
                    function( response ) {
                        response.sobjects.forEach(
                            function( sObj ) {
                                if( 
                                    sObj.getBoolean( "createable" )     && 
                                    sObj.getBoolean( "layoutable" )     && 
                                    !sObj.getBoolean( "customSetting" ) && 
                                    !sObj.getBoolean( "deprecatedAndHidden" )
                                ) {
                                    if( sObj.label !== "" ) {
                                        self.sObjects.push(
                                            {
                                                name  : sObj.name,
                                                label : sObj.label
                                            }
                                        );
                                    }
                                }
                            }
                        );
                        
                        self.selectedSObjects = self.sObjects[0].name;
                        
                        self.showProgress( false );
                        
                        $scope.$apply();
                        
                        self.components.select.initialize();
                    }
                );
            };
            
            this.getUnivRequiredFields = function() {
                self.requiredFields = {};
                
                if( !( self.selectedSObjects instanceof Array ) ) {
                    self.selectedSObjects = [ self.selectedSObjects ];
                }
                
                sforce.connection.describeSObjects(
                    self.selectedSObjects,
                    function( responses ) {
                        responses.forEach(
                            function( sObject ) {
                                self.requiredFields[ sObject.name ] = [];
                                
                                sObject.fields.forEach(
                                    function( field ) {
                                        if( 
                                            field.getBoolean( "createable" ) &&
                                            field.type !== "boolean" &&
                                            (
                                                self.requiredOnPageLayouts.indexOf( field.name ) !== -1 ||
                                                !field.getBoolean( "nillable" )
                                            )
                                        ) {
                                            self.requiredFields[ sObject.name ].push(
                                                {
                                                    label                   : field.label,
                                                    name                    : field.name,
                                                    type                    : field.type,
                                                    pageLayoutRequired      : !field.getBoolean( "nillable" ) || self.requiredOnPageLayouts.indexOf( field.name ) !== -1,
                                                    universallyRequired     : !field.getBoolean( "nillable" )
                                                }
                                            );
                                        }
                                    }
                                );
                            }
                        );
                        
                        self.showRequiredFields( true );
                        
                        self.showProgress( false );
                        
                        $scope.$apply();
                    }
                );
            };
            
            this.getPLRequiredFields = function( callback ) {
                this.requiredOnPageLayouts = [];
                
                try {
                    var detailLayoutSections = sforce.connection.describeLayout( 
                        this.selectedSObjects,
                        null,
                        null,
                        function( response ) {
                            if( !( response.layouts.detailLayoutSections instanceof Array ) ) {
                                response.layouts.detailLayoutSections = [ response.layouts.detailLayoutSections ];
                            }
                            
                            response.layouts.detailLayoutSections.forEach(
                                function( section ) {
                                    if( !( section.layoutRows instanceof Array ) ) {
                                        section.layoutRows = [ section.layoutRows ];
                                    }
                                    
                                    section.layoutRows.forEach(
                                        function( row ) {
                                            if( !( row.layoutItems instanceof Array ) ) {
                                                row.layoutItems = [ row.layoutItems ];
                                            }
                                            
                                            row.layoutItems.forEach(
                                                function( item ) {
                                                    if( item.getBoolean( "required" ) ) {
                                                        self.requiredOnPageLayouts.push( item.layoutComponents.value );
                                                    }
                                                }
                                            );
                                        }
                                    );
                                }
                            );
                            
                            callback();
                        }
                    );
                }
                catch( e ) {
                    callback();
                }
            };
            
            this.getRequiredFields = function() {
                this.showProgress( true );
                
                this.getPLRequiredFields( this.getUnivRequiredFields );
            };
            
            this.initialize = function( sessionId ) {
                sforce.connection.sessionId = sessionId;
                
                this.fetchSObjects();
            };
        }
    ]
);