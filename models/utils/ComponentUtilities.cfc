component 
    hint = "I represent bunch of useful component utilities"
{
    
    function init() {
        return this;
    }    
    
    
    /*
        GET COMPONENT PROPERTIES
        Returns the properties of the passed component "this" scope.
        note: components that are extended will have their parent's metadata in a key called "extends"
        this method will recursively look through all parents to retrieve all properties
        if any child overwrites a parent property, this method will respect that.
    */
    array function getPropertyList( required Component component ) {

        var deepProperties = getDeepProperties( getMetaData( arguments.component ), {} );
        
        var propertyList = [];
        
        deepProperties.each( function( key, value ) {
            propertyList.append( value );
        } );

        return propertyList;

    }

    /**
     *  Get Deep Properties
     *  This recursive function accepts component metadata and returns a structure containing
     *  all of the properties. 
     */
    private struct function getDeepProperties( required struct metaData, required struct properties ) {

        if ( 
            structKeyExists( metaData, "extends" ) && 
            structKeyExists( metaData.extends, "properties" )
        ) {
            structAppend( arguments.properties, getDeepProperties( metaData.extends, arguments.properties ) );
        }

        if ( structKeyExists( metaData, "properties" ) ) {

            for ( var newProperty in metaData.properties ) {
                arguments.properties[ newProperty.name ] = newProperty;
            }

        }

        return arguments.properties;

    }

    /*
        GET COMPONENT Functions
        Returns the functions of the passed component "this" scope
    */
    private array function getComponentFunctions() {

        return getMetadata( this ).functions;

    }


    private function getPublicPropertyList( required Component component ) {

        var source = arguments.component;

        var publicPropertyList = getPropertyList( source ).filter( function( property ) {
            
            // if the source component has a public getter method for this property, treat it as public and allow it
            return ( structKeyExists( source, "get#property.name#" ) );

        } );

        return publicPropertyList;

    }


    /*
        GET DTO
        Converts a component's properties into a data transformation object (DTO)
        which is essentially just a basic structure of data. Useful when sending data
        from layer to layer.
        todo: we need recursion here to go deeper into the dto and convert queries as needed.
        perhaps with an option in the arguments
        old method: deserializeJSON( serializeJSON( dto, "struct") );
    */
    public struct function getDto( required Component component ) {

        var dto = {}; // our default dto is an empty struct
        var source = arguments.component; // we need a reference because of the member function below

        // retrieve a list of public properties
        var publicPropertyList = getPublicPropertyList( source );

        publicPropertyList.each( function( property ) {   
            
            try {
                dto[ property.name ] = evaluate( "source.get#property.name#()" );
            } catch( any e ) {
                throw( "error running this.get#property.name#() in component #getMetaData( source ).name#: #e.message#");
            }

            // if the property is nullable, and we are missing the value from the dto, add a null value to the dto
            if ( 
                structKeyExists( property, "nullable" ) &&
                booleanFormat( property.nullable ) && 
                !structKeyExists( dto, property.name )
            ) {
                
                dto[ property.name ] = "";

            } else if ( !structKeyExists( dto, property.name ) ) {

                dto[ property.name ] = "[undefined value]";

            } else {
                
                dto[ property.name ] = convertDtoValue( dto[ property.name ] );

            }

        } );

        return dto;

    }


    // todo: case for structs containing objects
    private function convertDtoValue( required any value ) {
        
        // is this property value an object? and does it have a getDto method?
        if (
            isObject( arguments.value ) &&
            structKeyExists( arguments.value, "getDto" )
        ) {

            // replace the key with the original query object.
            return arguments.value.getDto();

        // else if it is an object without a dto, just convert it
        } else if ( isObject( arguments.value ) ) {

            return deserializeJSON( serializeJSON( arguments.value, "struct") );

        // is this property value an array?
        // it's possible that it could be an array of objects.
        } else if ( isArray( arguments.value ) ) {

            return arguments.value.map( function( item ) {
                return convertDtoValue( item );
            } );

        }

        // assert: the value is simple enough, just return it
        return value;

    }

    private string function hashify( required any value ) {
        
        //return an empty string for null
        if (IsNull(arguments.value)) {
            return "";
        }

        //return a simple value
        if (IsSimpleValue(arguments.value)) {
            return Hash(arguments.value, "MD5");
        }

        //return binary value in Base64
        if (IsBinary(arguments.value)) {
            return hashify(value=ToBase64(arguments.value));
        }

        //serialize ColdFusion objects
        if (IsObject(arguments.value)) {
            return hashify(value=ObjectSave(arguments.value));
        }

        //struct
        if (IsStruct(arguments.value)) {
            var values = "";
            for (var key in arguments.value) {
                values &= hashify(value=key) & hashify(value=arguments.value[key]);
            }
            return hashify(value=values);
        }

        //array
        if (IsArray(arguments.value)) {
            var values = "";
            for(var i=ArrayLen(arguments.value); i > 0; i--){
                values &= hashify(value=i) & hashify(value=arguments.value[i]);
            }
            return hashify( value = values );
        }

        //query
        if ( isQuery( arguments.value ) ) {
            return hashify( value=ObjectSave( arguments.value ) );
        }
        
    }

}