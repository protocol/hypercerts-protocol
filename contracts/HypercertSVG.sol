// SPDX-License-Identifier: MIT
// Ref: https://github.com/solv-finance/solv-v2-ivo/blob/main/vouchers/bond-voucher/contracts/BondVoucherDescriptor.sol

pragma solidity ^0.8.14;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "./lib/DateTime.sol";
import "hardhat/console.sol";

contract HypercertSVG {
    using StringsUpgradeable for uint256;

    struct SVGParams {
        string name;
        string description;
        uint64[2] workTimeframe;
        uint64[2] impactTimeframe;
        uint256 units;
        uint256 totalUnits;
    }

    /// @dev voucher => claimType => background colors
    mapping(address => mapping(uint8 => string[])) public certBgColors;
    mapping(uint256 => string) background;
    uint256 backgroundCounter = 0;

    event BackgroundAdded(uint256 id);

    constructor() {}

    function addBackground(string memory svgString) external returns (uint256 id) {
        id = backgroundCounter;
        background[id] = svgString;
        emit BackgroundAdded(id);
        backgroundCounter += 1;
    }

    function generateSvgHypercert(
        string memory name,
        string memory description,
        uint64[2] memory workTimeframe,
        uint64[2] memory impactTimeframe,
        uint256 totalUnits
    ) external view virtual returns (string memory) {
        SVGParams memory svgParams;
        svgParams.name = name;
        svgParams.description = description;
        svgParams.workTimeframe = workTimeframe;
        svgParams.impactTimeframe = impactTimeframe;
        svgParams.totalUnits = totalUnits;
        return _generateHypercert(svgParams);
    }

    function generateSvgFraction(
        string memory name,
        string memory description,
        uint64[2] memory workTimeframe,
        uint64[2] memory impactTimeframe,
        uint256 units,
        uint256 totalUnits
    ) external view virtual returns (string memory) {
        SVGParams memory svgParams;
        svgParams.name = name;
        svgParams.description = description;
        svgParams.workTimeframe = workTimeframe;
        svgParams.impactTimeframe = impactTimeframe;
        svgParams.units = units;
        svgParams.totalUnits = totalUnits;
        return _generateHypercertFraction(svgParams);
    }

    function _generateHypercert(SVGParams memory params) internal view virtual returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<svg width="550" height="850" viewBox="0 0 550 850" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">',
                    _generateFontLoader(),
                    _generateBackgroundColor(),
                    _generateBackground(),
                    '<g font-family="SpaceMono-Bold">',
                    _generateHeader(params),
                    _generateName(params),
                    _generateImpactScope(params),
                    _generateFooter(params),
                    "</g>",
                    "</svg>"
                )
            );
    }

    function _generateHypercertFraction(SVGParams memory params) internal view virtual returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<svg width="550" height="850" viewBox="0 0 550 850" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">',
                    _generateFontLoader(),
                    _generateBackgroundColor(),
                    _generateBackground(),
                    '<g font-family="SpaceMono-Bold">',
                    _generateHeader(params),
                    _generateName(params),
                    _generateImpactScope(params),
                    _generateFraction(params),
                    _generateFooter(params),
                    "</g>",
                    "</svg>"
                )
            );
    }

    // function _generateBackground() internal view virtual returns (string memory) {
    //     return string.concat('<g id="graphic-color">', string(abi.encodePacked(background[0])), "</g>");
    // }
    function _generateBackgroundColor() internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<g id="background-color">',
                    '<rect id="background-color-2" data-name="background-color" x=".5" y="0" width="550" height="850" rx="32" ry="32"/>',
                    "</g>"
                )
            );
    }

    function _generateBackground() internal pure virtual returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<g id="graphic-color">'
                    '<path id="graphic-color-2" data-name="graphic-color" d="M550,549.2v10.09M0,377.81v14.63m550,231.'
                    "19c-.18,.23-.38,.46-.55,.7-11.56,15.88-5.59,49.54,.55,83.4M22.44,1.45c43.82,15.91,96.81,49.05,127"
                    ".62,39.05,14.42-4.68,27.24-20.76,39.64-40.5m360.27,30.37c-40.37-9.32-124.04,64.14-163.41,51.36-21"
                    ".96-7.13-39.33-46.57-57.69-81.72m-122.58,0c-15.5,28.49-31.05,55.11-49.53,61.11C120.9,72.75,51.9,"
                    "19.9,6.73,12.38M0,355.47c31.02,23.15,87.5,50.73,87.5,69.53S31.02,471.39,0,494.53m0-174.72c36.48-4."
                    "18,111.44,11.26,123.26-4.99,15.34-21.08-51.33-124.9-30.26-140.24,20.87-15.19,98.95,80.17,124.02,72."
                    "03,24.19-7.85,31.16-131.16,57.97-131.16s33.78,123.31,57.97,131.16c25.07,8.14,103.15-87.22,124.02-"
                    "72.03,21.08,15.34-45.6,119.16-30.26,140.24,11.82,16.24,86.78,.81,123.26,4.99M0,266.3c16.49-2.76,"
                    "29.76-7.11,35.61-15.15C57.64,220.88-.94,108.96,29.33,86.93c29.97-21.81,118.21,68.31,154.21,"
                    "56.62C218.28,132.28,236.5,7.12,275,7.12s56.72,125.16,91.46,136.44c36,11.69,124.25-78.43,154.21-56."
                    "62,30.27,22.03-28.31,133.94-6.28,164.21,5.85,8.04,19.12,12.39,35.61,15.15M174.16,425c0-17.46-116.3-"
                    "53.12-111.18-68.88,5.3-16.33,120.51,23.23,130.4,9.64,9.99-13.73-63.16-111.07-49.43-121.06,13.59-9."
                    "89,83.54,89.66,99.87,84.36,15.76-5.12,13.73-126.94,31.19-126.94s15.43,121.83,31.19,126.94c16.33,"
                    "5.3,86.27-94.25,99.86-84.36,13.73,9.99-59.42,107.33-49.43,121.06,9.89,13.59,125.1-25.97,130.4-9.64"
                    ",5.12,15.76-111.18,51.42-111.18,68.88s116.3,53.12,111.18,68.88c-5.3,16.33-120.51-23.23-130.4-9."
                    "64-9.99,13.73,63.16,111.07,49.43,121.06-13.59,9.89-83.54-89.66-99.87-84.36-15.76,5.12-13.73,126."
                    "94-31.19,126.94s-15.43-121.83-31.19-126.94c-16.33-5.3-86.27,94.25-99.86,84.36-13.73-9.99,59.42-107"
                    ".33,49.43-121.06-9.89-13.59-125.1,25.97-130.4,9.64-5.12-15.76,111.18-51.42,111.18-68.88Zm-65,0c0-"
                    "24.47-115.19-66.89-108.02-88.97,7.43-22.89,125.78,10.58,139.64-8.48,14-19.24-54.29-121.44-35.05-135"
                    ".44,19.05-13.86,95.09,82.54,117.98,75.11,22.08-7.17,26.8-130.11,51.28-130.11s29.19,122.94,51.28,130"
                    ".11c22.89,7.43,98.93-88.98,117.98-75.11,19.24,14-49.05,116.2-35.05,135.44,13.86,19.05,132.21-14.41,"
                    "139.65,8.48,7.17,22.08-108.02,64.49-108.02,88.97s115.19,66.89,108.02,88.97c-7.43,22.89-125.78-10.58"
                    "-139.64,8.48-14,19.24,54.29,121.44,35.05,135.44-19.05,13.86-95.09-82.54-117.98-75.11-22.08,7.17-26."
                    "8,130.11-51.28,130.11s-29.19-122.94-51.28-130.11c-22.89-7.43-98.93,88.98-117.98,75.11-19.24-14,49."
                    "05-116.2,35.05-135.44-13.86-19.05-132.21,14.41-139.65-8.48-7.17-22.08,108.02-64.49,108.02-88.97ZM0,"
                    "310.19c39.43-.74,94.91,6.77,105.73-8.11,16.68-22.92-48.38-128.36-25.46-145.03,22.69-16.51,102.8,77."
                    "8,130.06,68.95,26.3-8.54,35.52-132.22,64.67-132.22s38.37,123.68,64.67,132.22c27.26,8.85,107.37-85."
                    "46,130.06-68.95,22.92,16.68-42.14,122.12-25.46,145.03,10.82,14.87,66.3,7.37,105.73,8.11m-332.5,114."
                    "81c0-12.79-117.04-43.95-113.29-55.48,3.88-11.96,116.99,31.67,124.24,21.72,7.32-10.05-69.07-104.16-"
                    "59.02-111.47,9.95-7.24,75.83,94.4,87.79,90.52,11.54-3.75,5.01-124.83,17.79-124.83s6.25,121.09,17.79"
                    ",124.83c11.96,3.88,77.83-97.76,87.79-90.52,10.05,7.32-66.34,101.42-59.02,111.47,7.24,9.95,120.35-33"
                    ".68,124.24-21.72,3.75,11.54-113.29,42.7-113.29,55.48s117.04,43.95,113.29,55.48c-3.88,11.96-116.99-"
                    "31.67-124.24-21.72-7.32,10.05,69.07,104.16,59.02,111.47-9.95,7.24-75.83-94.4-87.79-90.52-11.54,3.75"
                    "-5.01,124.83-17.79,124.83s-6.25-121.09-17.79-124.83c-11.96-3.88-77.83,97.76-87.79,90.52-10.05-7.32,"
                    "66.34-101.42,59.02-111.47-7.24-9.95-120.35,33.68-124.24,21.72-3.75-11.54,113.29-42.7,113.29-55.48Zm"
                    "-21.67,0c0-15.12-116.67-48.53-112.24-62.18,4.59-14.14,118.75,27.45,127.32,15.68,8.65-11.89-66.12-107"
                    ".61-54.23-116.27,11.77-8.57,79.68,92.03,93.83,87.44,13.65-4.43,9.37-125.89,24.49-125.89s10.84,121.46"
                    ",24.49,125.89c14.14,4.59,82.05-96.01,93.83-87.44,11.89,8.65-62.88,104.38-54.23,116.27,8.57,11.77,122"
                    ".73-29.82,127.32-15.68,4.43,13.65-112.24,47.06-112.24,62.18s116.67,48.53,112.24,62.18c-4.59,14.14-"
                    "118.75-27.45-127.32-15.68-8.65,11.89,66.12,107.61,54.23,116.27-11.77,8.57-79.68-92.03-93.83-87.44-"
                    "13.65,4.43-9.37,125.89-24.49,125.89s-10.84-121.46-24.49-125.89c-14.14-4.59-82.05,96.01-93.83,87.44-"
                    "11.89-8.65,62.88-104.38,54.23-116.27-8.57-11.77-122.73,29.82-127.32,15.68-4.43-13.65,112.24-47.06,"
                    "112.24-62.18Zm-43.33,0c0-19.8-115.93-57.71-110.13-75.57,6.01-18.52,122.27,19.01,133.48,3.6,11.33-15.57-60.2-114.53-44.64-125.86,15.41-11.22,87.39,87.29,105.9,81.28,17.86-5.8,18.08-128,37.88-128s20.02,122.2,37.88,128c18.52,6.01,90.49-92.49,105.9-81.28,15.57,11.33-55.97,110.29-44.64,125.86,11.22,15.41,127.47-22.12,133.48-3.6,5.8,17.86-110.13,55.78-110.13,75.57s115.93,57.71,110.13,75.57c-6.01,18.52-122.27-19.01-133.48-3.6-11.33,15.57,60.2,114.53,44.64,125.86-15.41,11.22-87.39-87.29-105.9-81.28-17.86,5.8-18.08,128-37.88,128s-20.02-122.2-37.88-128c-18.52-6.01-90.49,92.49-105.9,81.28-15.57-11.33,55.97-110.29,44.64-125.86-11.22-15.41-127.47,22.12-133.48,3.6-5.8-17.86,110.13-55.78,110.13-75.57Zm-21.67,0c0-22.14-115.56-62.3-109.07-82.27,6.72-20.7,124.02,14.79,136.56-2.44,12.67-17.4-57.25-117.99-39.84-130.65,17.23-12.54,91.24,84.92,111.94,78.19,19.97-6.49,22.44-129.05,44.58-129.05s24.61,122.57,44.58,129.05c20.7,6.72,94.71-90.73,111.94-78.2,17.4,12.67-52.51,113.25-39.84,130.65,12.54,17.23,129.84-18.26,136.56,2.44,6.49,19.97-109.07,60.14-109.07,82.27s115.56,62.3,109.07,82.27c-6.72,20.7-124.02-14.79-136.56,2.44-12.67,17.4,57.25,117.99,39.84,130.65-17.23,12.54-91.24-84.92-111.94-78.19-19.97,6.49-22.44,129.05-44.58,129.05s-24.61-122.57-44.58-129.05c-20.7-6.72-94.71,90.73-111.94,78.2-17.4-12.67,52.51-113.25,39.84-130.65-12.54-17.23-129.84,18.26-136.56-2.44-6.49-19.97,109.07-60.14,109.07-82.27ZM0,392.44c13.12,11.7,22.5,22.85,22.5,32.56s-9.38,20.87-22.5,32.56m0-79.75c23.22,16.96,44.16,33.7,44.16,47.19s-20.95,30.23-44.16,47.19M527.56,1.45c-43.82,15.91-96.81,49.05-127.62,39.05-14.42-4.68-27.24-20.76-39.64-40.5m135.4,0c-33.73,14.87-67.28,29.19-89.72,21.91-9.69-3.15-18.71-11.16-27.36-21.91m-49.77,850c18.36-35.15,35.73-74.59,57.69-81.72,39.37-12.78,123.04,60.67,163.41,51.36M171.37,0c-8.65,10.75-17.66,18.76-27.36,21.91C121.57,29.19,88.02,14.87,54.29,0M0,366.16c30.05,20.7,65.83,42.55,65.83,58.84S30.05,463.15,0,483.84m0-193.13c31.43-.82,61.9-2.04,70.67-14.1,19.35-26.59-42.46-135.27-15.87-154.62,26.33-19.16,110.51,73.06,142.14,62.79,30.52-9.91,44.24-134.33,78.07-134.33s47.55,124.42,78.07,134.33c31.63,10.27,115.81-81.95,142.14-62.79,26.59,19.35-35.22,128.03-15.87,154.62,8.78,12.06,39.24,13.28,70.67,14.1m0-235.19c-1.14-1.37-2.41-2.6-3.86-3.65-33.61-24.46-125.92,63.57-166.29,50.46-25.28-8.21-43.73-64.1-65.36-102.33M0,300.8c36.8-.21,78.34,2.1,88.2-11.45,18.01-24.75-45.42-131.81-20.67-149.83,24.51-17.84,106.65,75.43,136.1,65.87,28.41-9.22,39.88-133.27,71.37-133.27s42.96,124.05,71.37,133.27c29.44,9.56,111.59-83.71,136.1-65.87,24.75,18.01-38.68,125.07-20.67,149.83,9.86,13.55,51.4,11.25,88.2,11.45M298.48,0c26.73,33.4,45.61,113.51,74.68,122.95,38.19,12.4,128.47-76.68,160.25-53.54,32.1,23.36-24.85,136.9-1.49,169,3.7,5.08,10.02,8.85,18.08,11.77m-6.73-237.8c-45.17,7.52-114.17,60.37-150.02,48.73-18.47-6-34.03-32.62-49.53-61.11m206.28,472.19c-23.22-16.96-44.16-33.7-44.16-47.19s20.95-30.23,44.16-47.19M0,794.47c1.14,1.37,2.41,2.6,3.86,3.65,33.61,24.46,125.92-63.57,166.29-50.46,25.28,8.21,43.73,64.1,65.36,102.33M0,250.18c8.06-2.92,14.38-6.69,18.08-11.77,23.36-32.1-33.59-145.64-1.49-169,31.79-23.13,122.06,65.94,160.25,53.54,29.07-9.44,47.95-89.54,74.68-122.95M6.73,837.62c45.17-7.52,114.17-60.37,150.02-48.73,18.47,6,34.03,32.62,49.53,61.11M.04,819.63c40.37,9.32,124.04-64.14,163.41-51.36,21.96,7.13,39.33,46.57,57.69,81.72m328.86-366.16c-30.05-20.7-65.83-42.55-65.83-58.84s35.78-38.15,65.83-58.84m0,128.38c-31.02-23.15-87.5-50.73-87.5-69.53s56.47-46.39,87.5-69.53M235.5,0c-21.63,38.24-40.08,94.13-65.36,102.33C129.77,115.44,37.46,27.42,3.86,51.87c-1.45,1.05-2.72,2.28-3.86,3.65M22.44,848.55c43.82-15.91,96.81-49.05,127.62-39.05,14.42,4.68,27.24,20.76,39.64,40.5M221.14,0c-18.36,35.15-35.73,74.59-57.69,81.72C124.08,94.51,40.41,21.05,.04,30.37M360.31,850c12.4-19.74,25.21-35.82,39.64-40.5,30.81-10,83.79,23.13,127.62,39.05m-148.93,1.45c8.65-10.75,17.66-18.76,27.36-21.91,22.44-7.29,56,7.04,89.72,21.91m-151.99,0c15.5-28.49,31.05-55.11,49.53-61.11,35.85-11.64,104.85,41.21,150.02,48.73m-488.98,12.38c33.73-14.87,67.28-29.19,89.72-21.91,9.69,3.15,18.71,11.16,27.36,21.91m378.63-310.19c-39.43,.74-94.91-6.77-105.73,8.11-16.68,22.92,48.38,128.36,25.46,145.03-22.69,16.51-102.8-77.8-130.06-68.95-26.3,8.54-35.52,132.22-64.67,132.22s-38.37-123.68-64.67-132.22c-27.26-8.85-107.37,85.46-130.06,68.95-22.92-16.68,42.14-122.12,25.46-145.03-10.82-14.87-66.3-7.37-105.73-8.11m550-9.62c-36.48,4.18-111.44-11.26-123.26,4.99-15.34,21.08,51.33,124.9,30.26,140.24-20.87,15.19-98.95-80.17-124.02-72.03-24.19,7.85-31.16,131.16-57.97,131.16s-33.78-123.31-57.97-131.16c-25.07-8.14-103.15,87.22-124.02,72.03-21.08-15.34,45.6-119.16,30.26-140.24-11.82-16.24-86.78-.81-123.26-4.99m550,19.01c-36.8,.21-78.34-2.1-88.2,11.45-18.01,24.75,45.42,131.81,20.67,149.83-24.51,17.84-106.65-75.43-136.1-65.87-28.41,9.22-39.88,133.27-71.37,133.27s-42.96-124.05-71.37-133.27c-29.44-9.56-111.59,83.71-136.1,65.87-24.75-18.01,38.68-125.07,20.67-149.83-9.86-13.55-51.4-11.25-88.2-11.45m314.5,300.8c21.63-38.24,40.08-94.13,65.36-102.33,40.37-13.11,132.68,74.92,166.29,50.46,1.45-1.05,2.72-2.28,3.86-3.65m0-194.65c-8.06,2.92-14.38,6.69-18.08,11.77-23.36,32.1,33.59,145.64,1.49,169-31.79,23.13-122.06-65.94-160.25-53.54-29.07,9.44-47.95,89.54-74.68,122.95m-59.32-425c0-10.45-117.41-39.36-114.35-48.79,3.17-9.77,115.24,35.89,121.16,27.76,5.98-8.22-72.03-100.7-63.82-106.68,8.13-5.92,71.98,96.78,81.75,93.6,9.43-3.06,.65-123.78,11.09-123.78s1.67,120.72,11.09,123.78c9.77,3.17,73.61-99.52,81.75-93.6,8.22,5.98-69.79,98.47-63.81,106.68,5.92,8.13,117.98-37.53,121.16-27.76,3.06,9.43-114.35,38.34-114.35,48.79s117.41,39.36,114.35,48.79c-3.17,9.77-115.24-35.89-121.16-27.76-5.98,8.22,72.03,100.7,63.82,106.68-8.13,5.92-71.98-96.78-81.75-93.6-9.43,3.06-.65,123.78-11.09,123.78s-1.67-120.72-11.09-123.78c-9.77-3.17-73.61,99.52-81.75,93.6-8.22-5.98,69.79-98.47,63.81-106.68-5.92-8.13-117.98,37.53-121.16,27.76-3.06-9.43,114.35-38.34,114.35-48.79ZM0,279.42c24.45-1.85,45.67-5.26,53.14-15.54,20.69-28.43-39.51-138.73-11.08-159.42,28.15-20.48,114.36,70.69,148.17,59.71,32.63-10.59,48.6-135.38,84.76-135.38s52.14,124.79,84.76,135.38c33.82,10.98,120.03-80.19,148.17-59.71,28.43,20.69-31.77,130.99-11.08,159.42,7.48,10.27,28.69,13.69,53.14,15.54M251.52,850c-26.73-33.4-45.61-113.51-74.68-122.95-38.19-12.4-128.47,76.68-160.25,53.54-32.1-23.36,24.85-136.9,1.49-169-3.7-5.08-10.02-8.85-18.08-11.77m550-142.26c-13.12-11.7-22.5-22.85-22.5-32.56s9.38-20.87,22.5-32.56m0,166.85c-31.43,.82-61.9,2.04-70.67,14.1-19.35,26.59,42.46,135.27,15.87,154.62-26.33,19.16-110.51-73.06-142.14-62.79-30.52,9.91-44.24,134.33-78.07,134.33s-47.55-124.42-78.07-134.33c-31.63-10.27-115.81,81.95-142.14,62.79-26.59-19.35,35.22-128.03,15.87-154.62-8.78-12.06-39.24-13.28-70.67-14.1m550,11.3c-24.45,1.85-45.67,5.26-53.14,15.54-20.69,28.43,39.51,138.73,11.08,159.42-28.15,20.48-114.36-70.69-148.17-59.71-32.63,10.59-48.6,135.38-84.76,135.38s-52.14-124.79-84.76-135.38c-33.82-10.98-120.03,80.19-148.17,59.71-28.43-20.69,31.77-130.99,11.08-159.42-7.48-10.27-28.69-13.69-53.14-15.54m550,13.12c-16.49,2.76-29.76,7.11-35.61,15.15-22.03,30.27,36.55,142.18,6.28,164.21-29.97,21.81-118.21-68.31-154.21-56.62-34.74,11.28-52.96,136.44-91.46,136.44s-56.72-125.16-91.46-136.44c-36-11.69-124.25,78.43-154.21,56.62-30.27-22.03,28.31-133.94,6.28-164.21-5.85-8.04-19.12-12.39-35.61-15.15"
                    '" style="fill: none; stroke: #ffce43; stroke-miterlimit: 10; stroke-width: 2px;"/>',
                    "</g>"
                )
            );
    }

    function _generateHeader(SVGParams memory params) internal pure virtual returns (string memory) {
        (uint256 yearFrom, uint256 monthFrom, uint256 dayFrom) = DateTime.timestampToDate(params.workTimeframe[0]);
        (uint256 yearTo, uint256 monthTo, uint256 dayTo) = DateTime.timestampToDate(params.workTimeframe[1]);

        return
            string(
                abi.encodePacked(
                    abi.encodePacked(
                        '<g id="foreground-color">',
                        '<path id="foreground-color-2" data-name="foreground-color" d="M435,777.83H115v-50H435v50Zm0-532.83H115v360H435V245Zm0-122.83H115v-50H435v50Z"/>',
                        "</g>"
                    ),
                    abi.encodePacked(
                        '<g id="divider-color" text-rendering="optimizeSpeed" font-size="10" fill="#ffce43">',
                        '<path id="divider-color-2" data-name="divider-color" d="M156.35,514.59h237.31" style="fill: none; stroke: #ffce43; stroke-miterlimit: 10; stroke-width: 2px;"/>',
                        '<text id="work-period-color" transform="translate(134.75 102.06)" style="font-family: Inter-Regular, Inter; font-size: 15px;">',
                        '<tspan x="0" y="0" style="letter-spacing: -.05em;">Work Period: ',
                        abi.encodePacked(yearFrom.toString(), "-", monthFrom.toString(), "-", dayFrom.toString()),
                        " > ",
                        abi.encodePacked(yearTo.toString(), "-", monthTo.toString(), "-", dayTo.toString()),
                        "</tspan></text></g>"
                    )
                )
            );
    }

    function _generateName(SVGParams memory params) internal pure virtual returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<g id="name-color" text-rendering="optimizeSpeed" font-size="30">',
                    abi.encodePacked(
                        '<text id="scope-title-color" transform="translate(156.35 343.77)" style="fill: #ffce43; font-family: SpaceMono-Bold, Space Mono; ">',
                        '<tspan x="0" y="0">',
                        params.name,
                        "</tspan></text>"
                    ),
                    "</g>"
                )
            );
    }

    function _generateFontLoader() internal pure virtual returns (string memory) {
        return
            string.concat(
                "<style>",
                '@import url("https://fonts.googleapis.com/css?family=Inter:200,300,400,500,600,700,800,900");',
                '@import url("https://fonts.googleapis.com/css?family=Space+Mono:400,400i,700,700i");',
                "</style>"
            );
        // return "@import url('https://fonts.googleapis.com/css2?family=Inter:wght@200;300;400;500;600;700;800;900%26family=Space+Mono:ital,wght@0,400;0,700;1,400;1,700%26display=swap')";
    }

    function _generateImpactScope(SVGParams memory params) internal pure virtual returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<g id="scope-category-color" text-rendering="optimizeSpeed" font-size="15" fill="white">',
                    '<text transform="translate(156.35 500)" style="font-family: Inter-Regular, Inter; font-size: 15px;">',
                    '<tspan x="0" y="0">',
                    params.description,
                    "</tspan></text></g>"
                )
            );
    }

    function _generateFraction(SVGParams memory params) internal pure virtual returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<g id="scope-category-color" text-rendering="optimizeSpeed" font-size="30">',
                    '<text id="fractiom-color" transform="translate(156.35 568.03)" style="fill: #ffce43; font-family: SpaceMono-Bold, Space Mono">'
                    '<tspan x="0" y="0">',
                    abi.encodePacked(params.units.toString(), " / ", params.totalUnits.toString()),
                    "</tspan></text></g>"
                )
            );
    }

    function _generateTotalUnits(SVGParams memory params) internal pure virtual returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<g id="scope-category-color" text-rendering="optimizeSpeed" font-size="30">',
                    '<text id="fractiom-color" transform="translate(156.35 568.03)" style="fill: #ffce43; font-family: SpaceMono-Bold, Space Mono">'
                    '<tspan x="0" y="0">',
                    params.totalUnits.toString(),
                    "</tspan></text></g>"
                )
            );
    }

    function _generateFooter(SVGParams memory params) internal pure virtual returns (string memory) {
        (uint256 yearFrom, uint256 monthFrom, uint256 dayFrom) = DateTime.timestampToDate(params.impactTimeframe[0]);
        (uint256 yearTo, uint256 monthTo, uint256 dayTo) = DateTime.timestampToDate(params.impactTimeframe[1]);
        return
            string(
                abi.encodePacked(
                    '<g id="divider-color" text-rendering="optimizeSpeed" font-size="10" fill="#ffce43">',
                    '<text id="impact-period-color" transform="translate(134.75 765)" style="font-family: Inter-Regular, Inter; font-size: 15px;">',
                    '<tspan x="0" y="0" style="letter-spacing: -.05em;">Impact Period: ',
                    abi.encodePacked(yearFrom.toString(), "-", monthFrom.toString(), "-", dayFrom.toString()),
                    " > ",
                    abi.encodePacked(yearTo.toString(), "-", monthTo.toString(), "-", dayTo.toString()),
                    "</tspan></text></g>"
                )
            );
    }
}
