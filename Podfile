# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def general_pods
  pod 'MessageKit', '1.0.0'
  pod 'IBMWatsonAssistantV2', '~> 2.3.0'
  pod 'Charts'
  pod 'Alamofire', '< 5'
  pod 'Alamofire-SwiftyJSON', '3.0.0'
end


target 'Nova' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  general_pods

  # Pods for Nova

  target 'NovaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'NovaUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  	

end
