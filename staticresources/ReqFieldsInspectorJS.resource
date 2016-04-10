angular.module( "reqFieldsInspectApp", [] ).controller(
    "ReqFieldsInspectCtrl",
    [
        "$scope",
        function( $scope ) {
            var self                 = this;
            this.processing          = true;
            this.sObjects            = [];
            this.requiredFields      = [];
            this.requiredFieldsShown = false;
            this.components          = {
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
                                if( sObj.getBoolean( "createable" ) ) {
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
                        
                        self.sObjects = self.sObjects.sort(
                            function( a, b ) {
                                if( a.name > b.name ) {
                                    return 1;
                                }
                                else if( b.name > a.name ) {
                                    return -1;
                                }
                                
                                return 0;
                            }
                        );
                        
                        self.selectedSObjects = self.sObjects[0].name;
                        
                        self.showProgress( false );
                        
                        $scope.$apply();
                        
                        self.components.select.initialize();
                    }
                );
            };
            
            this.getRequiredFields = function() {
                this.showProgress( true );
                
                this.requiredFields = {};
                
                var requiredOnPageLayouts = [];
                try {
                    var detailLayoutSections = sforce.connection.describeLayout( this.selectedSObjects ).layouts.detailLayoutSections;
                    
                    detailLayoutSections.forEach(
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
                                                requiredOnPageLayouts.push( item.layoutComponents.value );
                                            }
                                        }
                                    );
                                }
                            );
                        }
                    );
                }
                catch( e ) {
                }
                
                if( !( this.selectedSObjects instanceof Array ) ) {
                    this.selectedSObjects = [ this.selectedSObjects ];
                }

                sforce.connection.describeSObjects(
                    this.selectedSObjects,
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
                                                requiredOnPageLayouts.indexOf( field.name ) !== -1 ||
                                                !field.getBoolean( "nillable" )
                                            )
                                        ) {
                                            self.requiredFields[ sObject.name ].push(
                                                {
                                                    label                   : field.label,
                                                    name                    : field.name,
                                                    type                    : field.type,
                                                    pageLayoutRequired      : !field.getBoolean( "nillable" ) || requiredOnPageLayouts.indexOf( field.name ) !== -1,
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
            
            this.initialize = function( sessionId ) {
                sforce.connection.sessionId = sessionId;
                
                this.fetchSObjects();
            };
        }
    ]
);