# Kernel package build action for Revolution Pi

This action buils a kernel for Revolution Pi and creates the debian packages for kernel and kernel-headers

## Inputs

## `changelog_author`

**Required** The name of the changelog author. Default `"Revolution Pi Development Team"`.

## `changelog_author_email`

**Required** The email of the changelog author. Default `"development@revolutionpi.de"`.

## `changelog_update`

**Required** Switch for automatically update of the changelog based on build date and commit id. Default `1`.

## Outputs

## `filename_kernel`

Filename of the kernel package

## `filename_headers`

Filename of the kernel-headers package

## Example usage

uses: RevolutionPi/action-build-kernel@v1
with:
  changelog_update: 1
