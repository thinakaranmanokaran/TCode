// Production stub for `prop-types` (used only by react-helmet-async for
// dev-time validation). Bundling the real package added ~20 KB of
// checkPropTypes/factory code to the PageMeta chunk and inflated mobile
// TBT. React 19 strips propTypes in production anyway.
//
// Validators must be chainable: PropTypes.string.isRequired, etc.
const validator = () => null;
validator.isRequired = validator;

const PropTypes = new Proxy(
  {
    checkPropTypes: () => null,
    resetWarningCache: () => {},
    // Common validators as chainable stubs
    any: validator,
    array: validator,
    bool: validator,
    func: validator,
    number: validator,
    object: validator,
    string: validator,
    symbol: validator,
    node: validator,
    element: validator,
    elementType: validator,
    objectOf: () => validator,
    arrayOf: () => validator,
    shape: () => validator,
    exact: () => validator,
    oneOf: () => validator,
    oneOfType: () => validator,
    instanceOf: () => validator,
  },
  {
    get: (target, prop) => {
      if (prop in target) return target[prop];
      return validator;
    },
  },
);
export default PropTypes;
