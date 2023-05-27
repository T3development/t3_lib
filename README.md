# t3_lib

A library for multi framework/inventory support for t3 scripts.

## Installation

> Drag *t3_lib* into your server's resources folder and add `ensure t3_lib` to your *server.cfg* (this must be before any t3 scripts)

> Set your options in the *config.lua* choosing your framework etc.

> Edit the notify function in the *client/main.lua* to suit your notification system (common ones are available to uncomment).

> If you are starting any t3 scripts in a folder eg.`ensure [t3]`, do not put t3_lib in the same folder as it will restart and not initialise correctly

### Supported Frameworks

> *ESX*
> *QBCore*

### Supported Inventories

> *ox_inventory*
> *qs-inventory*
> *qb-inventory*
> *mf-inventory*
> Default ESX inventory functions (this doesn't handle any metadata)