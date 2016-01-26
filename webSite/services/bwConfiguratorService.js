/**
 * Created by tedshaffer on 1/26/16.
 */
angular.module('bwConfiguratorApp').service('bwConfiguratorService', ['$http', function($http, $bwConfiguratorService){

    console.log("bwConfiguratorService invoked");

    this.baseUrl = "http://10.1.0.169:8008/";

    this.launchBWConfigurator = function() {
        var self = this;
        return new Promise(function(resolve, reject) {
            var url = self.baseUrl + "LaunchBWConfigurator";
            var promise = $http.get(url, {});
            promise.then(function(result) {
                resolve(result);
            }, function(reason) {
                reject();
            })
        })
    }
}]);
