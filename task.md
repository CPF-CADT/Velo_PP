# Mobile Development 2 Final Project

## Git Issues Backlog (Main Tasks + Subtasks)

Use this directly in Jira or GitHub Issues.

## Issue 1: US1 - Pass Selection and Active Pass Rules (Rothanak)

- Type: Story
- Priority: High

### Description

Implement full pass selection and activation logic with one active pass maximum and expiration handling.

### Acceptance Criteria

- ✓ User can choose Day, Monthly, and Annual pass.
- ✓ Each pass has start date and expiration date.
- ✓ User cannot have more than one active pass at a time.
- ✓ If buying a new pass, the previous active pass is replaced or deactivated.

### Subtasks

- [✓] Add repository write methods for pass purchase and activation.
- [✓] Add ViewModel actions in passes module to purchase and select pass.
- [✓] Update pass UI cards with action states: Select, Buy, Active, Expired.
- [✓] Implement single active pass replacement rule.
- [✓] Add expiration helper methods such as isExpired and isActiveNow.
- [✓] Add tests for single active pass behavior.

---

## Issue 2: US2 - Station Map Completion and Visual Highlight (Vathanak)

- Type: Story
- Priority: High

### Description

Complete map behavior to match user story highlighting and station information rules.

### Acceptance Criteria

- All stations are displayed on the map.
- Each station shows number of bikes available.
- Stations with available bikes are visually highlighted compared to empty stations.

### Subtasks

- [ ] Update marker color logic based on bikesAvailable > 0.
- [ ] Add distinct style or icon for empty stations.
- [ ] Ensure map list and bottom sheet sorting by nearest and availability.
- [ ] Add loading, error, and empty-state polish for map screen.
- [ ] Add widget tests for marker color and highlight rules.

---

## Issue 3: US3 - Bike Slots at Selected Station (Chan Panha)

- Type: Story
- Priority: High

### Description

When selecting a station, show slot list with status per slot.

### Acceptance Criteria

- Selecting station opens station details with slot list.
- Each slot shows one status: Available bike or Empty slot.
- Slot list reflects mock data and updates after booking.

### Subtasks

- [ ] Create docks repository abstraction and mock implementation.
- [ ] Create station details ViewModel to load station slots.
- [ ] Build station slots screen or modal UI.
- [ ] Show slot status badge and bike info when occupied.
- [ ] Connect station tap from map to station slots screen.
- [ ] Add tests for slot status rendering.

---

## Issue 4: US4 - Bike Booking Flow with Pass or Ticket Decision

- Type: Story
- Priority: Critical

### Description

Implement booking flow with conditional logic based on active pass.

### Acceptance Criteria

- User selects available bike and opens booking screen.
- If user has active pass, user can confirm booking directly.
- If user has no pass, user can choose single ticket or go to pass selection.
- After booking, the bike is no longer available at the station.

### Subtasks

- [ ] Add booking create and update methods in bookings repository.
- [ ] Add bike availability mutation in bikes and docks repository.
- [ ] Build booking screen with bike and station summary.
- [ ] Implement branch logic: active pass vs no pass.
- [ ] Implement single ticket purchase option placeholder.
- [ ] Refresh map and station data after successful booking.
- [ ] Persist and show newly created booking in rides screen.
- [ ] Add tests for both booking cases and bike availability update.

---

## Issue 5: US5 - Payment Flow (Nice to Have, Mock Only)

- Type: Story
- Priority: Medium

### Description

Implement payment simulation for ticket and pass purchases.

### Scope Note

Payment is mock only for this project milestone (no real payment gateway integration).

### Acceptance Criteria

- Payment is required for single ticket and pass purchase flows.
- Payment is simulated using mock methods only.
- On successful mock payment, pass or ticket is activated.
- User can continue booking confirmation after successful mock payment.

### Subtasks

- [ ] Create payment method model and payment result model.
- [ ] Build payment screen with mock methods (card, cash, wallet).
- [ ] Add payment status handling (success, fail, cancel).
- [ ] Integrate mock payment into pass purchase flow.
- [ ] Integrate mock payment into single ticket flow.
- [ ] Add tests for mock payment success and failure handling.

---

## Issue 6: Architecture and Technical Cleanup for Jury

- Type: Task
- Priority: High

### Description

Align implementation with project evaluation rubric for widgets, state, and data architecture quality.

### Acceptance Criteria

- Reusable components extracted.
- No repeated hard-coded styles.
- ViewModel owns logic and View remains presentation-focused.
- DTO, repository, and model flow is consistent in new features.

### Subtasks

- [ ] Fix unused warnings and minor analyzer issues.
- [ ] Refactor repeated map and pass card styles into shared widgets.
- [ ] Add loading and error states to all new screens.
- [ ] Add localization keys for booking, payment, and pass text.
- [ ] Add QA checklist for jury demo scenario.

---

## Issue 7: Firebase Transition Plan (Optional)

- Type: Task
- Priority: Medium

### Description

Prepare migration path from mock repositories to Firebase repositories.

### Acceptance Criteria

- Firebase collections designed for stations, bikes and docks, passes, and bookings.
- Mapping from model and DTO to Firebase documents is defined.
- Mock and real repositories can be switched by provider configuration.

### Subtasks

- [ ] Define Firestore schema and indexes.
- [ ] Add repository interfaces for create and update operations.
- [ ] Implement Firebase repository classes.
- [ ] Add environment switch in provider setup.
- [ ] Smoke test booking and pass flow on Firebase.

---

## Suggested Implementation Order

1. US3 then US4 (core booking flow)
2. US1 (pass rules used by booking flow)
3. US2 polish
4. US5 mock payment integration
5. Issue 6 cleanup and jury readiness
6. Issue 7 optional Firebase migration
