/**
 * Created by tedshaffer on 1/26/16.
 */
//angular.module('bwConfiguratorApp').controller('bwConfigurator', ['$scope', '$location', 'bwConfiguratorService', function ($scope, $location, $bwConfiguratorService) {
angular.module('bwConfiguratorApp').controller('bwConfigurator', ['$scope', 'bwConfiguratorService', function ($scope, $bwConfiguratorService) {

    console.log("bwConfigurator controlled invoked");
    $bwConfiguratorService.launchBWConfigurator();

}]);
