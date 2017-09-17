// base contract for the urbit constitution
// encapsulates dependencies all constitutions need.

pragma solidity 0.4.15;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/token/MintableToken.sol';

import './Ships.sol';
import './Votes.sol';

contract ConstitutionBase is Ownable
{
  Ships public ships;
  Votes public votes;
  MintableToken public USP;

  bool public deprecated;

  function ConstitutionBase()
  {
    //
  }

  function setContracts(Ships _ships, Votes _votes, MintableToken _USP)
    external
    onlyOwner //TODO? onlyOldConstitution
  {
    ships = _ships;
    votes = _votes;
    USP = _USP;
  }

  function upgrade(address _new)
    internal
  {
    ships.transferOwnership(_new);
    votes.transferOwnership(_new);
    USP.transferOwnership(_new);
    deprecated = true;
    selfdestruct(_new);
  }

  // to ensure all calls to outdated constitutions explicitly fail, we tag all
  // public functions with this modifier.
  modifier latest()
  {
    require(!deprecated);
    _;
  }
}
