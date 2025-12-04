import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';

/// Modal de filtros avançados
///
/// Exibe opções de filtragem incluindo:
/// - Price Range com sliders
/// - Delivery Time
/// - Condition (radio buttons)
/// - Colour (checkboxes coloridos)
/// - Rating (estrelas)
/// - Weight (checkboxes)
/// - Delivery regions (cards selecionáveis)
class FiltersModal extends StatefulWidget {
  const FiltersModal({super.key});

  @override
  State<FiltersModal> createState() => _FiltersModalState();

  /// Exibe a modal de filtros
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: FiltersModal(),
      ),
    );
  }
}

class _FiltersModalState extends State<FiltersModal>
    with SingleTickerProviderStateMixin {
  // Tab Controller
  late TabController _tabController;
  int _selectedTabIndex = 1; // Advanced Filters selecionado por padrão

  // Price Range
  RangeValues _priceRange = const RangeValues(300, 3500);
  final double _minPrice = 0;
  final double _maxPrice = 5000;

  // Delivery Time
  double _deliveryTime = 30;
  final double _maxDeliveryTime = 60;

  // Condition
  String _selectedCondition = 'All';

  // Colours
  final Set<String> _selectedColours = {'Gray', 'Green'};
  final List<_ColourOption> _colourOptions = [
    _ColourOption('Blue', FlowbiteColors.blue500),
    _ColourOption('Gray', FlowbiteColors.gray500),
    _ColourOption('Green', FlowbiteColors.green500),
    _ColourOption('Pink', FlowbiteColors.pink500),
    _ColourOption('Red', FlowbiteColors.red500),
  ];

  // Rating
  int? _selectedRating = 4;

  // Weight
  final Set<String> _selectedWeights = {'Under 1kg', '2.5-3kg'};
  final List<String> _weightOptions = [
    'Under 1kg',
    '1-1.5kg',
    '1.5-2kg',
    '2.5-3kg',
    'Over 3kg',
  ];

  // Delivery Regions
  String _selectedDelivery = 'USA';
  final List<_DeliveryOption> _deliveryOptions = [
    _DeliveryOption('USA', 'Delivery only for USA'),
    _DeliveryOption('Europe', 'Delivery only for Europe'),
    _DeliveryOption('Asia', 'Delivery only for Asia'),
    _DeliveryOption('Australia', 'Delivery only for Australia'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onReset() {
    setState(() {
      _priceRange = const RangeValues(300, 3500);
      _deliveryTime = 30;
      _selectedCondition = 'All';
      _selectedColours.clear();
      _selectedColours.addAll({'Gray', 'Green'});
      _selectedRating = 4;
      _selectedWeights.clear();
      _selectedWeights.addAll({'Under 1kg', '2.5-3kg'});
      _selectedDelivery = 'USA';
    });
  }

  void _onShowResults() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: context.colorTheme.bgNeutralPrimary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: FlowbiteColors.gray900.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceRange(context),
                  const SizedBox(height: 24),
                  _buildDeliveryTime(context),
                  const SizedBox(height: 24),
                  _buildCondition(context),
                  const SizedBox(height: 24),
                  _buildColourAndRating(context),
                  const SizedBox(height: 24),
                  _buildWeight(context),
                  const SizedBox(height: 24),
                  _buildDeliveryRegions(context),
                  const SizedBox(height: 24),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filters',
            style: context.customTextTheme.textLgSemibold.copyWith(
              color: context.colorTheme.fgHeading,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              size: 20,
              color: context.colorTheme.fgBodySubtle,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          _buildTab(context, 'Brand', 0),
          const SizedBox(width: 16),
          _buildTab(context, 'Advanced Filters', 1),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, int index) {
    final isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.customTextTheme.textSmMedium.copyWith(
              color: isSelected
                  ? FlowbiteColors.blue600
                  : context.colorTheme.fgBodySubtle,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: label.length * 8.0,
            color: isSelected ? FlowbiteColors.blue600 : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRange(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabs(context),
        Container(
          height: 1,
          color: context.colorTheme.borderDefault,
          margin: const EdgeInsets.only(bottom: 20),
        ),
        Text(
          'Price Range',
          style: context.customTextTheme.textSmSemibold.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: FlowbiteColors.blue600,
            inactiveTrackColor: context.colorTheme.bgNeutralTertiary,
            thumbColor: FlowbiteColors.blue600,
            overlayColor: FlowbiteColors.blue600.withOpacity(0.1),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: RangeSlider(
            values: _priceRange,
            min: _minPrice,
            max: _maxPrice,
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPriceInput(
                context,
                _priceRange.start.round().toString(),
                (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null &&
                      parsed >= _minPrice &&
                      parsed <= _priceRange.end) {
                    setState(() {
                      _priceRange = RangeValues(parsed, _priceRange.end);
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'to',
                style: context.customTextTheme.textSm.copyWith(
                  color: context.colorTheme.fgBodySubtle,
                ),
              ),
            ),
            Expanded(
              child: _buildPriceInput(
                context,
                _priceRange.end.round().toString(),
                (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null &&
                      parsed >= _priceRange.start &&
                      parsed <= _maxPrice) {
                    setState(() {
                      _priceRange = RangeValues(_priceRange.start, parsed);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceInput(
    BuildContext context,
    String value,
    ValueChanged<String> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: context.colorTheme.borderDefault),
        borderRadius: BorderRadius.circular(8),
        color: context.colorTheme.bgNeutralPrimary,
      ),
      child: Text(
        value,
        style: context.customTextTheme.textSm.copyWith(
          color: context.colorTheme.fgBody,
        ),
      ),
    );
  }

  Widget _buildDeliveryTime(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Min Delivery Time (Days)',
          style: context.customTextTheme.textSmSemibold.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: FlowbiteColors.blue600,
            inactiveTrackColor: context.colorTheme.bgNeutralTertiary,
            thumbColor: FlowbiteColors.blue600,
            overlayColor: FlowbiteColors.blue600.withOpacity(0.1),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: _deliveryTime,
            min: 0,
            max: _maxDeliveryTime,
            onChanged: (value) {
              setState(() {
                _deliveryTime = value;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: context.colorTheme.borderDefault),
            borderRadius: BorderRadius.circular(8),
            color: context.colorTheme.bgNeutralPrimary,
          ),
          child: Text(
            _deliveryTime.round().toString(),
            style: context.customTextTheme.textSm.copyWith(
              color: context.colorTheme.fgBody,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCondition(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Condition',
          style: context.customTextTheme.textSmSemibold.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildConditionRadio(context, 'All'),
            const SizedBox(width: 24),
            _buildConditionRadio(context, 'New'),
            const SizedBox(width: 24),
            _buildConditionRadio(context, 'Used'),
          ],
        ),
      ],
    );
  }

  Widget _buildConditionRadio(BuildContext context, String label) {
    final isSelected = _selectedCondition == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCondition = label;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? FlowbiteColors.blue600
                    : context.colorTheme.borderDefault,
                width: 2,
              ),
              color: context.colorTheme.bgNeutralPrimary,
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: FlowbiteColors.blue600,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: context.customTextTheme.textSm.copyWith(
              color: context.colorTheme.fgBody,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColourAndRating(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildColours(context)),
        const SizedBox(width: 24),
        Expanded(child: _buildRating(context)),
      ],
    );
  }

  Widget _buildColours(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colour',
          style: context.customTextTheme.textSmSemibold.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(_colourOptions.length, (index) {
          final option = _colourOptions[index];
          final isSelected = _selectedColours.contains(option.name);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedColours.remove(option.name);
                  } else {
                    _selectedColours.add(option.name);
                  }
                });
              },
              child: Row(
                children: [
                  _buildCheckbox(context, isSelected),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: option.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    option.name,
                    style: context.customTextTheme.textSm.copyWith(
                      color: context.colorTheme.fgBody,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCheckbox(BuildContext context, bool isSelected) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected
              ? FlowbiteColors.blue600
              : context.colorTheme.borderDefault,
          width: 2,
        ),
        color: isSelected
            ? FlowbiteColors.blue600
            : context.colorTheme.bgNeutralPrimary,
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 12, color: FlowbiteColors.white)
          : null,
    );
  }

  Widget _buildRating(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating',
          style: context.customTextTheme.textSmSemibold.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(5, (index) {
          final stars = 5 - index;
          final isSelected = _selectedRating == stars;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRating = stars;
                });
              },
              child: Row(
                children: [
                  _buildRadioIndicator(context, isSelected),
                  const SizedBox(width: 8),
                  ...List.generate(5, (starIndex) {
                    return Icon(
                      starIndex < stars ? Icons.star : Icons.star_border,
                      size: 16,
                      color: starIndex < stars
                          ? FlowbiteColors.yellow300
                          : context.colorTheme.fgBodySubtle,
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRadioIndicator(BuildContext context, bool isSelected) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? FlowbiteColors.blue600
              : context.colorTheme.borderDefault,
          width: 2,
        ),
        color: context.colorTheme.bgNeutralPrimary,
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: FlowbiteColors.blue600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildWeight(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight',
          style: context.customTextTheme.textSmSemibold.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(_weightOptions.length, (index) {
          final option = _weightOptions[index];
          final isSelected = _selectedWeights.contains(option);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedWeights.remove(option);
                  } else {
                    _selectedWeights.add(option);
                  }
                });
              },
              child: Row(
                children: [
                  _buildCheckbox(context, isSelected),
                  const SizedBox(width: 8),
                  Text(
                    option,
                    style: context.customTextTheme.textSm.copyWith(
                      color: context.colorTheme.fgBody,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDeliveryRegions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery',
          style: context.customTextTheme.textSmSemibold.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemCount: _deliveryOptions.length,
          itemBuilder: (context, index) {
            final option = _deliveryOptions[index];
            final isSelected = _selectedDelivery == option.region;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDelivery = option.region;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? FlowbiteColors.blue600
                        : context.colorTheme.borderDefault,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: context.colorTheme.bgNeutralPrimary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      option.region,
                      style: context.customTextTheme.textSmSemibold.copyWith(
                        color: isSelected
                            ? FlowbiteColors.blue600
                            : context.colorTheme.fgHeading,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.description,
                      style: context.customTextTheme.textXs.copyWith(
                        color: context.colorTheme.fgBodySubtle,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _onShowResults,
            style: ElevatedButton.styleFrom(
              backgroundColor: FlowbiteColors.blue600,
              foregroundColor: FlowbiteColors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              'Show 50 results',
              style: context.customTextTheme.textSmSemibold.copyWith(
                color: FlowbiteColors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed: _onReset,
          style: OutlinedButton.styleFrom(
            foregroundColor: context.colorTheme.fgBody,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(color: context.colorTheme.borderDefault),
          ),
          child: Text(
            'Reset',
            style: context.customTextTheme.textSmMedium.copyWith(
              color: context.colorTheme.fgBody,
            ),
          ),
        ),
      ],
    );
  }
}

class _ColourOption {
  final String name;
  final Color color;

  const _ColourOption(this.name, this.color);
}

class _DeliveryOption {
  final String region;
  final String description;

  const _DeliveryOption(this.region, this.description);
}
