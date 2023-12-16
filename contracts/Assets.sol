

library Assets {

    //function assetname as string and gives back a string 
    function getAsset(string memory assetname) public pure returns (string memory) {
        return "asset";
    }

    function getNightMask(string memory assetname) public pure returns (string memory) {
        return "nightmask";

    }

    function hasNightMask(string memory assetname) public pure returns (bool) {
        return true;
    }


}