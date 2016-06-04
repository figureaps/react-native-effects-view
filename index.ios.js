/**
 * ReactNativeEffectsView
 * http://github.com/voronianski/react-native-effects-view
 */

'use strict';

var React = require('react');
var {
    View,
    PropTypes,
    StyleSheet
} = require('react-native');
var cloneWithProps = require('react-addons-clone-with-props');
var ReactNativeViewAttributes = require('react-native/Libraries/Components/View/ReactNativeViewAttributes');
var createReactNativeComponentClass = require('react-native/Libraries/ReactNative/createReactNativeComponentClass');
var NativeMethodsMixin = require('react-native/Libraries/ReactIOS/NativeMethodsMixin');
var flattenStyle = require('react-native/Libraries/StyleSheet/flattenStyle');
var merge = require('react-native/Libraries/Utilities/mergeFast');

var EffectsViewComponent = React.createClass({
    mixins: [NativeMethodsMixin],

    propTypes: {
        blurStyle: PropTypes.string,
        vibrantContent: PropTypes.node,
    },

    viewConfig: {
        validAttributes: ReactNativeViewAttributes.UIView,
        uiViewClassName: 'UIView',
    },

    render() {
        var { children, vibrantContent } = this.props;
        var style = flattenStyle([styles.base, this.props.style]);
        var nativeProps = merge(this.props, { style });

        if (vibrantContent) {
            nativeProps.vibrant = true;
        }
        var vibrantNode = vibrantContent ? vibrantContent : <View />;

        return (
            <EffectsView {...nativeProps}>
                {vibrantNode}
                {React.Children.map(children, cloneWithProps)}
            </EffectsView>
        );
    }
});

var EffectsView = createReactNativeComponentClass({
    validAttributes: merge(ReactNativeViewAttributes.UIView, {
        blurStyle: true,
        vibrant: true
    }),
    uiViewClassName: 'DVEffectsView'
});

var styles = StyleSheet.create({
    base: {
        backgroundColor: 'transparent'
    }
});

module.exports = EffectsViewComponent;
