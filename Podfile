# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Watcher' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  #inherit! :search_paths
  pod 'SwiftLint'
  pod 'Alamofire'
  pod 'KeychainSwift'
  pod 'ReachabilitySwift'
  pod 'GRDB.swift'
  pod 'SQLite.swift', '~> 0.11.5'
  pod 'RealmSwift'

  target 'WatcherTests' do
      inherit! :search_paths
  end

end

target 'WatcherUITests' do
  # inherit! :search_paths
end

target 'Persistancy' do
  use_frameworks!
  pod 'GRDB.swift'
  pod 'SQLite.swift', '~> 0.11.5'
  pod 'RealmSwift'

  target 'PersistancyTests' do
      inherit! :search_paths
  end

end

target 'apiClient' do
  use_frameworks!
  pod 'Alamofire'
  pod 'KeychainSwift'

  target 'apiClientTests' do
    inherit! :search_paths
  end

end
