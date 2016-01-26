/**
 * Created by tedshaffer on 1/26/16.
 */
angular
    .module('bwConfiguratorApp', ['ngRoute'])

    .controller('bwCtrl', function($scope, $location){

        console.log("pizza rocks");
    })

    .config(['$routeProvider', function ($routeProvider) {

        $routeProvider

            .when('/', {
                templateUrl: 'bwConfigurator.html',
                controller: 'bwConfigurator'
            })
    }]);
