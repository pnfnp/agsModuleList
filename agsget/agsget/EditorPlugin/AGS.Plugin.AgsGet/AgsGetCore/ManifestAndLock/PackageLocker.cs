using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

// The PackageLocker is meant to produce a lock file using the manifest and package index as inputs
// It's function is to analyze dependencies and write the lock file
// The lock file is the complete list of packages to install, including dependencies, and install order.

// note: We still don't have versions, so for now we will write them only for registering.
// once we do have versions, this step will fail if two packages depend on different versions of the same package.

namespace AgsGetCore
{
    class PackageLocker
    {
        private const string LockFile = "agsget-lock.json";

        private static string GetLockFilePath()
        {
            return Path.Combine(BaseFiles.GetRunDirectory(), LockFile);
        }

        private static void WriteToLock(string contents)
        {
            System.IO.File.WriteAllText(GetLockFilePath(), contents);
        }

        private static List<KeyValuePair<MinimalPackageDescriptor, List<MinimalPackageDescriptor>>> BuildDependencyGraph(
            List<MinimalPackageDescriptor> packagesToInstall,
            List<Package> index)
        {
            return null;
        }
        private static List<MinimalPackageDescriptor> FlatOrderedDependencies(
            List<KeyValuePair<MinimalPackageDescriptor, List<MinimalPackageDescriptor>>> dependencyGraph)
        {
            return null;
        }

        private static bool AreAllPackagesOnIndex(List<MinimalPackageDescriptor> packages)
        {
            List<string> packageIDs = packages.Select(p => p.id).ToList();
            return PackageCacheIO.AreAllPackagesOnIndex(packageIDs);
        }

        public static bool Lock()
        {
            if (!BaseFiles.ExistsIndexFile())
            {
                // we don't even have an index, we need one before adding packages for installation
                return false;
            }

            if (!IntentDescriptor.ManifestExists())
            {
                // we don't have a manifest file to follow, nothing to do here
                return false;
            }

            var manifest = IntentDescriptor.GetManifestAsList();

            if (!AreAllPackagesOnIndex(manifest))
            {
                // if not all packages are on the index, our dependency graph generation will fail
                // note: we will skip checking if the index itself is sane here - has all dependencies it can point to.
                return false;
            }

            if(manifest.Count() <= 0)
            {
                // our manifest is empty, we generate a empty lock
                WriteToLock("[]\r\n");
                return true;
            }



            return true;
        }
    }
}