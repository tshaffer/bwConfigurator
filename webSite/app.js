/**
 * Created by tedshaffer on 1/26/16.
 */
angular
    .module('bwConfiguratorApp', ['ngRoute'])

    .config(['$routeProvider', function ($routeProvider) {

        $routeProvider

            .when('/', {
                templateUrl: 'index.html',
                controller: 'bwConfigurator'
            })
    }]);
