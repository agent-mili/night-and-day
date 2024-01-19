    pragma solidity ^0.8.0;

    // import Location struct from SeaPorts.sol
    import "./Seaports.sol";
    import "./SAM.sol";

    
    library NDAlgos {

    uint256 constant TO_RAD = 17453292519943296;
    uint256 constant TO_DEG = 57295779513224454144;

        // Define a structure for storing the best path information
    struct BestPath {
        uint[] path;
        uint distance;
        uint[] distances;
    }



    function findClosestPathToDistance( Seaports.Location[] memory locations, uint startIndex, uint endIndex, uint maxDistance) public view returns (BestPath memory) {
    BestPath memory bestPath = BestPath(new uint[](50), 0, new uint[](0));
    uint[] memory distances =  new uint[](30); 
    
    uint[] memory visited =  new uint[](37); // Mapping for visited nodes


   
    // Initialize visited for the start node
    visited[startIndex] = 1;

    // Call the recursive DFS function
    dfsClose(locations, startIndex, endIndex, maxDistance, new uint[](0),0, visited, 0, bestPath, distances);

    return bestPath;
}

 function checkClosestPath(
        uint currentNodeIndex,
        uint endIndex,
        uint[] memory path,
        uint pathLength,
        uint maxDistance,
        uint currentDistance,
        BestPath memory bestPath, // Using 'memory' as this is a temporary variable
        uint[] memory distances
    ) internal pure returns (bool, BestPath memory) { // Updated to return a tuple
        if (currentDistance > maxDistance) {
            return (true, bestPath);
        }
        if (currentNodeIndex == endIndex) {
            if (currentDistance > 0 && (bestPath.distance == 0 || currentDistance < bestPath.distance)) {
                // Update bestPath with new best values
                bestPath.distance = currentDistance;
                bestPath.path = new uint[](pathLength);
                bestPath.distances = new uint[](pathLength -1);

                // Copy the path and distances to bestPath
                for (uint i = 0; i < path.length; i++) {
                    bestPath.path[i] = path[i];
                }
                for (uint i = 0; i < distances.length; i++) {
                    bestPath.distances[i] = distances[i];
                }

                return (true, bestPath);
            }
        }
        return (false, bestPath);
    }

     // Function to perform depth-first search
    function dfsClose(
        Seaports.Location[] memory locations,
        uint currentLocationIndex,
        uint endIndex,
        uint maxDistance,
        uint[] memory path,
        uint pathLength,
        uint[] memory visited,
        uint currentDistance,
        BestPath memory bestPath,
        uint[] memory distances
    ) internal view{
        // Check if the current path is the closest or exceeds max distance
        bool foundClosest;
        (foundClosest, bestPath) = checkClosestPath(currentLocationIndex, endIndex, path, pathLength, maxDistance, currentDistance, bestPath, distances);
        if (foundClosest) return;

        // Get the current location 
        Seaports.Location memory currentLocation = locations[currentLocationIndex];

        // Iterate through the neighbors of the current node
        for (uint i = 0; i < currentLocation.neighbours.length; i++) {
            uint neighbourIndex = currentLocation.neighbours[i];

            // Check if the neighbor has been visited less than or equal to 1 time
            if (visited[neighbourIndex] <= 1) {
                // Update path and visited for the neighbor
           
                    path[pathLength] = neighbourIndex; // "Push" manually
                    pathLength++; // Don't forget to increment the length
                
                visited[neighbourIndex] = (visited[neighbourIndex] + 1);

                // Calculate the new distance (assuming getDistance is implemented)
                uint distance = 100;//SAM.getDistance(currentLocation.lat, currentLocation.lng, locations[neighbourIndex].lat, locations[neighbourIndex].lng);
               distances[pathLength -1] = distance; // "Push" manually
                uint newDistance = currentDistance + distance;

                // Recursively call dfsClose for the neighbor
                dfsClose(locations,neighbourIndex, endIndex, maxDistance, path, pathLength, visited, newDistance, bestPath, distances);

                // Backtrack: remove the neighbor from path and distances, decrement visited
                
              
                pathLength--;
                visited[neighbourIndex] = (visited[neighbourIndex] - 1);
            }
        }
    }


       function getAngleOfCoords(int lat1, int lng1, int lat2, int lng2) public pure returns (int) {
        int dLng = lng2 - lng1;
        int y = Trigonometry.sin(dLng) * Trigonometry.cos(lat2) / 1e18;
        int x = Trigonometry.cos(lat1) * Trigonometry.sin(lat2) / 1e18 - Trigonometry.sin(lat1) * Trigonometry.cos(lat2) * Trigonometry.cos(dLng) / 1e36;
        return p_atan2(y, x);
    }


    function getDistance(int lat1, int lng1, int lat2, int lng2) public pure returns (int) {
        int R = 6371 * 1e18; // Radius of the earth in km
        int dLat = (lat2 - lat1) * int(TO_DEG);  // deg2rad below
        int dLng = (lng2 - lng1) * int(TO_DEG); 
        int a = Trigonometry.sin(dLat / 2) * Trigonometry.sin(dLat / 2) / 1e18 + Trigonometry.cos(lat1) * Trigonometry.cos(lat2) * Trigonometry.sin(dLng / 2) * Trigonometry.sin(dLng / 2) / 1e52;
        int c = 2 * p_atan2(int(sqrt(uint(a))), int(sqrt(uint(1e18 - a))));
        int d = R * c; // Distance in km
        return d;
    }

    // port to solidity above js function
    function getCoordsOfMovingObject(int lat1, int lon1, int lat2, int lon2, int elapsedTime, int speed) public pure returns (int, int, int) {
        int R = 6371 * 1e18; // Radius of the earth in km
        int d = (speed * elapsedTime / 3600000); // distance in km

        // Umwandeln der Eingangsgrade in Radiant
        int lat1InRadians = lat1 * int(TO_RAD) / 1e18;
        int lon1InRadians = lon1 * int(TO_RAD) / 1e18;
        int lat2InRadians = lat2 * int(TO_RAD) / 1e18;
        int lon2InRadians = lon2 * int(TO_RAD) / 1e18;
        int angleInRadians = getAngleOfCoords(lat1InRadians, lon1InRadians, lat2InRadians, lon2InRadians);

        // Berechnung des neuen Breitengrads
        int currentLat = InverseTrigonometry.arcsin(Trigonometry.sin(lat1InRadians) * Trigonometry.cos(d / R) / 1e18 + 
                            Trigonometry.cos(lat1InRadians) * Trigonometry.sin(d / R) * Trigonometry.cos(angleInRadians)/ 1e36);

        // Berechnung des neuen Längengrads
        int currentlng = lon1InRadians + p_atan2(Trigonometry.sin(angleInRadians) * Trigonometry.sin(d / R) * Trigonometry.cos(lat1InRadians) / 1e36, 
                                    Trigonometry.cos(d / R) - Trigonometry.sin(lat1InRadians) * Trigonometry.sin(currentLat) / 1e18);

        return (currentLat * int(TO_DEG) / 1e18, currentlng * int(TO_DEG) / 1e18, angleInRadians * int(TO_DEG) / 1e18);
    }







    /// @notice ATAN2(Y,X) FUNCTION (MORE PRECISE MORE GAS)
    /// @param y y
    /// @param x x
    /// @return T T
    function p_atan2(int256 y, int256 x) public pure returns (int256 T) {
        int256 c1 = 3141592653589793300 / 4;
        int256 c2 = 3 * c1;
        int256 abs_y = y >= 0 ? y : -y;
        abs_y += 1e8;

        if (x >= 0) {
            int256 r = ((x - abs_y) * 1e18) / (x + abs_y);
            T = (1963e14 * r**3) / 1e54 - (9817e14 * r) / 1e18 + c1;
        } else {
            int256 r = ((x + abs_y) * 1e18) / (abs_y - x);
            T = (1963e14 * r**3) / 1e54 - (9817e14 * r) / 1e18 + c2;
        }
        if (y < 0) {
            return -T;
        } else {
            return T;
        }
    }




    }



