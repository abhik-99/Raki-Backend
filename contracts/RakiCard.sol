// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC721, ERC721URIStorage, Pausable, Ownable {
    struct CardDetails {
        bytes32 firstName;
        bytes32 lastName;
        uint64 officeNo;
        uint64 phoneNo;
        string occupation;
        string companyName;
        string website;
        string email;
        string linkedin;
    }

    mapping(uint256 => CardDetails) cardDetailsMapping;

    uint64 public tokenId = 0;

    constructor() ERC721("Raki Card", "RAKI") {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(
        address _to,
        string calldata _uri,
        CardDetails _cd
    ) public onlyOwner {
        uint256 _tokenId = tokenId;
        _safeMint(_to, _tokenId);
        _setTokenURI(_tokenId, _uri);
        cardDetailsMapping[_tokenId] = _cd;
        tokenId++;
    }

    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(_from, _to, _tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 _tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(_tokenId);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(_tokenId);
    }

    function tokenDetails(uint256 _tokenId) public view returns (CardDetails) {
      require(ownerOf(_tokenId) == _tokenId || msg.sender == owner(), "Unauthorized");
      return cardDetailsMapping[_tokenId]
    }
}
