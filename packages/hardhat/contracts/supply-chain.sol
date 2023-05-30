// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract SupplyChain {
    struct Product {
        uint id;
        string name;
        uint quantity;
        address currentOwner;
        address[] history;
    }

    mapping(uint => Product) public products;
    uint public productId;

    event ProductCreated(uint id, string name, uint quantity, address currentOwner);
    event ProductTransferred(uint id, address previousOwner, address newOwner);

   constructor() public {
    productId = 1;
}

    function createProduct(string memory _name, uint _quantity) public {
        Product storage product = products[productId];
        product.id = productId;
        product.name = _name;
        product.quantity = _quantity;
        product.currentOwner = msg.sender;
        product.history.push(msg.sender);

        emit ProductCreated(productId, _name, _quantity, msg.sender);

        productId++;
    }
    function addQuantity(uint _productId, uint _quantityToAdd) public {
    Product storage product = products[_productId];

    require(product.currentOwner == msg.sender, "You are not the current owner of the product.");

    product.quantity += _quantityToAdd;
}
function reduceQuantity(uint _productId, uint _quantityToReduce) public {
    Product storage product = products[_productId];

    require(product.currentOwner == msg.sender, "You are not the current owner of the product.");
    require(product.quantity >= _quantityToReduce, "Insufficient quantity.");

    product.quantity -= _quantityToReduce;
}
function getProductCount() public view returns (uint) {
    return productId - 1;
}
function getProductOwners(uint _productId) public view returns (address[] memory) {
    Product memory product = products[_productId];
    return product.history;
}
function checkProductAuthenticity(uint _productId, address _ownerAddress) public view returns (bool) {
    Product memory product = products[_productId];
    return (product.currentOwner == _ownerAddress);
}
function removeProduct(uint _productId) public {
    Product storage product = products[_productId];

    require(product.currentOwner == msg.sender, "You are not the current owner of the product.");

    delete products[_productId];
}



    function transferProduct(uint _productId, address _newOwner) public {
        Product storage product = products[_productId];

        require(product.currentOwner == msg.sender, "You are not the current owner of the product.");

        product.currentOwner = _newOwner;
        product.history.push(_newOwner);

        emit ProductTransferred(_productId, msg.sender, _newOwner);
    }

    function getProduct(uint _productId) public view returns (uint, string memory, uint, address, address[] memory) {
        Product memory product = products[_productId];

        return (product.id, product.name, product.quantity, product.currentOwner, product.history);
    }
}
